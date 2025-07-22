# SurveyBuilder.Blazor

A lightweight, extensible form builder for Blazor projects.  
Create, edit, and render surveys using a structured model. Built for reuse across apps.

## 📦 Installation

Add it via NuGet:

```sh
dotnet add package SurveyBuilder.Blazor
```

Or edit your .csproj:

```C#
<PackageReference Include="SurveyBuilder.Blazor" Version="1.1.*" />
```


## ⚙️ Usage
You can build surveys with the SurveyBuilder and render them in your host project (examples in samples/SurveyBuilder.DemoApp)

Surveys are exported as JSON blobs.


## 🧱 Defining a Survey

Use the SurveyModel, SurveyPage, and SurveyQuestion classes to build a form programmatically.

You can save this to storage or serialize to JSON.



## 🧪 Demo Project
The repository includes a sample Blazor demo:

📁 samples/SurveyBuilder.DemoApp

Run it with:
```bash
dotnet run --project samples/SurveyBuilder.DemoApp
```

This shows how to:
- Create/edit surveys with drag-and-drop
- Preview rendered forms
- Save/load surveys to memory
- Submit answers and receive results

## 💡 Customization
The package is designed to be extended. You can:

- Use your own persistence logic via ISurveyJsonService

## 📌 Roadmap
 UI polish and better drag/drop feedback

 Validation support

 Markdown support in labels

 Docs website