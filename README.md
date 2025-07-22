# SurveyBuilder.Blazor

A lightweight, extensible survey/form builder for Blazor applications. Create, edit, and manage surveys with a structured model that serializes to JSON for easy storage and retrieval.

## Features

- 🏗️ Build surveys programmatically or through UI
- ✏️ Edit existing surveys 
- 👁️ Real-time preview of survey forms
- 💾 JSON serialization/deserialization for easy storage
- 📝 Support for multiple question types:
  - Single choice (radio buttons)
  - Multiple choice (checkboxes)
  - Open-ended (text input)
  - Opinion scales (sliders)
  - Likert scales
- 🎨 Built with MudBlazor for a polished UI

## Installation

Add the package via NuGet:

```bash
dotnet add package SurveyBuilder.Blazor
```

Or add directly to your .csproj file:

```bash
<PackageReference Include="SurveyBuilder.Blazor" Version="1.1.*" />
```

## Core Concepts

### Survey Structure

- ```SurveyModel```: The root container for your survey 
	- Title and description
	- Collection of questions

- ```SurveyQuestionModel```: Defines individual questions
	- Question text
	- Question type
	- Options (for choice-based questions)
	- Required flag


## Basic Usage

### Creating a Survey
```csharp
var survey = new SurveyModel
{
    Title = "Customer Satisfaction Survey",
    Description = "Help us improve our services",
    Questions = new List<SurveyQuestionModel>
    {
        new()
        {
            Text = "How satisfied are you with our product?",
            Type = QuestionType.OpinionScale,
            Required = true
        },
        new()
        {
            Text = "What features would you like to see added?",
            Type = QuestionType.OpenEnded
        }
    }
};

// Serialize to JSON
var json = JsonService.Serialize(survey);
```

### Editing a Survey
The package provides UI components for visual survey editing:

```razor
<SurveyEditor Survey="@survey" OnSurveyChanged="@HandleSurveyChange" />
```

### Rendering a Survey
Display surveys to end-users:

```razor
<SurveyRenderer Survey="@survey" OnSubmit="@HandleSurveySubmission" />
```

## Demo Application
The repository includes a sample Blazor application demonstrating:
- Survey creation/editing interface
- Survey preview functionality
- JSON import/export
- Survey response collection

### To run the demo:

```bash
dotnet run --project samples/SurveyBuilder.DemoApp
```
### Extending Functionality
- Implement these interfaces for custom behavior:
	- ISurveyJsonService: Custom JSON serialization
	- ISurveyRepository: Custom survey storage


## Roadmap
- Enhanced drag-and-drop UI
- Validation support 
- Markdown formatting in labels
- Comprehensive documentation website
- Additional question types
- Survey analytics

## Contributing
Contributions are welcome! Please open issues for feature requests or bug reports.
