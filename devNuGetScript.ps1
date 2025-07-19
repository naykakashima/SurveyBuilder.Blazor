param (
    [string]$bump = "patch"
)

$projPath = "src/SurveyBuilder/SurveyBuilder.csproj"
$nupkgOut = "nupkg"
$hostAppPath = "samples/SurveyBuilder.DemoApp" # adjust this if your host app path changes

Write-Host "`n📦 Starting SurveyBuilder NuGet build process..." -ForegroundColor Cyan

# Load .csproj
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
    $suffix = $matches[4]  # "-dev" or null

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
}
else {
    Write-Host "❌ Could not parse version. Use format 'X.Y.Z[-dev]'" -ForegroundColor Red
    exit 1
}

# Pack
dotnet pack $projPath -c Debug -o $nupkgOut

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ dotnet pack failed." -ForegroundColor Red
    exit 1
}

Write-Host "`n🎉 Package built successfully!" -ForegroundColor Green
Write-Host "📦 Saved to: $nupkgOut" -ForegroundColor Yellow

# Refresh in host app
Write-Host "`n🔁 Refreshing package in host app..." -ForegroundColor Cyan
Push-Location $hostAppPath

dotnet remove package SurveyBuilder

Write-Host "✅ Add Package To Host Package Using NuGet Package Manager" -ForegroundColor Green

Pop-Location
