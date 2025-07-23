param (
    [ValidateSet("major", "minor", "patch")]
    [string]$bump = "patch",

    [switch]$publish
)

# Load .env if exists
$envFile = ".env"

if (Test-Path $envFile) {
    Get-Content $envFile | ForEach-Object {
        if ($_ -match "^\s*([^#=]+?)\s*=\s*(.+?)\s*$") {
            $key = $matches[1].Trim()
            $value = $matches[2].Trim().Trim("'`"")
            [System.Environment]::SetEnvironmentVariable($key, $value)
        }
    }
}

$projPath = "src/SurveyBuilder/SurveyBuilder.csproj"
$nupkgOut = "nupkg"
$hostAppPath = "samples/SurveyBuilder.DemoApp"

Write-Host "`n📦 Starting SurveyBuilder NuGet build process..." -ForegroundColor Cyan

[xml]$csproj = Get-Content $projPath
$versionNode = $csproj.Project.PropertyGroup | Where-Object { $_.Version } | Select-Object -First 1
$currentVersion = $versionNode.Version

if (-not $currentVersion) {
    Write-Host "❌ No <Version> tag found in .csproj" -ForegroundColor Red
    exit 1
}

Write-Host "📌 Current version: $currentVersion"

if ($currentVersion -match "^(\d+)\.(\d+)\.(\d+)(-dev)?$") {
    $major = [int]$matches[1]
    $minor = [int]$matches[2]
    $patch = [int]$matches[3]
    $suffix = if ($matches[4]) { $matches[4] } else { "" }

    switch ($bump.ToLower()) {
        "major" {
            $major += 1
            $minor = 0
            $patch = 0
        }
        "minor" {
            $minor += 1
            $patch = 0
        }
        default {
            $patch += 1
        }
    }

    $newVersion = "$major.$minor.$patch$suffix"
    $versionNode.Version = $newVersion
    $csproj.Save($projPath)

    Write-Host "✅ Bumped version to: $newVersion" -ForegroundColor Green
} else {
    Write-Host "❌ Could not parse version. Use format 'X.Y.Z[-dev]'" -ForegroundColor Red
    exit 1
}

$buildConfig = if ($suffix -eq "-dev") { "Debug" } else { "Release" }

# Clean output folder
if (Test-Path $nupkgOut) {
    Remove-Item "$nupkgOut\*" -Recurse -Force
} else {
    New-Item -ItemType Directory -Path $nupkgOut | Out-Null
}

Write-Host "`n🛠  Building NuGet package ($buildConfig)..." -ForegroundColor Cyan

# Build project first (helps with staticwebassets error)
dotnet build $projPath -c $buildConfig

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ dotnet build failed." -ForegroundColor Red
    exit 1
}

dotnet pack $projPath -c $buildConfig -o $nupkgOut --include-symbols

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ dotnet pack failed." -ForegroundColor Red
    exit 1
}

Write-Host "🎉 Package built successfully!"
Write-Host "📦 Output folder: $nupkgOut" -ForegroundColor Yellow

Write-Host "`n🔁 Refreshing package in host app..." -ForegroundColor Cyan
Push-Location $hostAppPath

try {
    dotnet remove package SurveyBuilder -ErrorAction SilentlyContinue | Out-Null
    dotnet add package SurveyBuilder --source "../../$nupkgOut" | Out-Null
    Write-Host "✅ Local host app refreshed with version $newVersion" -ForegroundColor Green
}
finally {
    Pop-Location
}

if ($publish) {
    Write-Host "`n🚀 Publishing to NuGet..." -ForegroundColor Magenta

    $nupkgFile = Get-ChildItem "$nupkgOut\SurveyBuilder.$newVersion.nupkg" -ErrorAction SilentlyContinue
    if (-not $nupkgFile) {
        Write-Host "❌ NuGet package file not found." -ForegroundColor Red
        exit 1
    }

    if (-not $env:NUGET_API_KEY) {
        Write-Host "❌ NUGET_API_KEY environment variable not set." -ForegroundColor Red
        exit 1
    }

    dotnet nuget push $nupkgFile.FullName `
        --api-key $env:NUGET_API_KEY `
        --source "https://api.nuget.org/v3/index.json"

    if ($LASTEXITCODE -eq 0) {
        Write-Host "🎯 Package pushed to NuGet.org!" -ForegroundColor Green
    } else {
        Write-Host "❌ Failed to publish package." -ForegroundColor Red
    }
}

Write-Host "`Visit: https://www.nuget.org/packages/SurveyBuilder" -ForegroundColor Blue
Write-Host "`n✅ All done!" -ForegroundColor Green