# SurveyBuilder.Blazor

A lightweight, extensible survey/form builder for Blazor applications. Create, edit, and manage surveys with a structured model that serializes to JSON for easy storage and retrieval.

Access the NuGet pacakge here: https://www.nuget.org/packages/SurveyBuilder

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

All you need to do to render the survey builder is to use the following code snippet:

```csharp
<SurveyBuilder SurveyChanged="@OnSurveyChanged" />

```

As well as the import statements

```csharp
@using SurveyBuilder.Models
@using SurveyBuilder.Services
@using SurveyBuilder.Components
```

### Example Usage

```csharp
<SurveyBuilder SurveyChanged="@OnSurveyChanged" />
<MudButton OnClick="SaveToDb" Color="Color.Primary" Class="mt-2">Save to DB</MudButton>

@code{

private Task OnSurveyChanged(SurveyModel survey)
    {
        CurrentSurvey = survey;
        Serialized = JsonService.Serialize(survey);
        return Task.CompletedTask;
    }



// Serialize to JSON
    private Task SaveToDb()
    {
        if (CurrentSurvey is null)
            return Task.CompletedTask;

        Console.WriteLine("Save triggered:");
        Console.WriteLine(Serialized);

        CurrentSurvey.Id = Guid.NewGuid().ToString();
        Repo.Add(CurrentSurvey);
        Nav.NavigateTo("/listsurveys");

        return Task.CompletedTask;
    }
}
```

### Editing a Survey
The DemoApp provides an example of how persistence could be incorporated via parent-child parameter bind between editing and creating the surveys

```razor
<SurveyBuilderEditor Survey="Survey" SurveyChanged="OnSurveyChanged" />

@code{
	protected override void OnInitialized()
	{
		var loaded = Repo.GetById(Id);

		if (loaded is not null)
		{
			// Detach from repo to prevent accidental mutation
			Survey = JsonService.Deserialize(JsonService.Serialize(loaded));
		}
	}

	private Task OnSurveyChanged(SurveyModel updated)
	{
		Survey = updated;
		return Task.CompletedTask;
	}
}
```

## Filling Up The Survey

A thorough decision has been made to not make filling the survey part of the package as it would result in dangerously high coupling and will significantly affect the freedom that the user will choose to do with the SurveyBuilder JSON.

As an alternative this is a highly reusable snippet taken from the DemoApp

```csharp
<MudText Typo="Typo.h5">@Survey.Title</MudText>
<MudText Typo="Typo.subtitle2" Class="mb-4">@Survey.Description</MudText>

<!-- TODO: Render dynamic questions here -->

<MudStack Spacing="2">
    @foreach (var question in Survey.Questions)
    {
        @switch (question.Type)
        {
            case QuestionType.OpenEnded:
                <MudTextField T="string"
                Placeholder="Type your answer here..."
                Value="@GetString(question.Id)"
                ValueChanged="val => SetString(question.Id, val)"
                />
                break;


            case QuestionType.SingleChoice:
                <MudRadioGroup T="string"
                Value="@GetString(question.Id)"
                ValueChanged="@(val => SetString(question.Id, val))">
                    @foreach (var option in question.Options!)
                    {
                        <MudRadio T="string" Value="@option" Label="@option"/>
                    }
                </MudRadioGroup>
                break;

            case QuestionType.OpinionScale:
                <MudSlider Min="1" 
                           Max="10"
                           Value="@(GetNullableInt(question.Id) ?? 5)"
                           ValueChanged="@((int val) => SetAnswer(question.Id, val))"
                           Immediate="true"/>
                <MudText>Selected: @(GetNullableInt(question.Id) ?? 5)/10</MudText>
                break;

            case QuestionType.LikertScale:
                <MudRadioGroup T="string"
                              Value="@GetString(question.Id)"
                              ValueChanged="@(val => SetString(question.Id, val))">
                    @foreach (var option in question.Options!)
                    {
                        <MudRadio T="string" Value="@option" Label="@option"/>
                    }
                </MudRadioGroup>
                break;


            case QuestionType.MultiChoice:
                @foreach (var option in question.Options!)
                {
                    <MudCheckBox T="bool"
                                Label="@option"
                                Value="@(GetList(question.Id).Contains(option))"
                                ValueChanged="@((bool val) => OnMultiChoiceChanged(question.Id, option, val))"/>
                }
                break;
        }
    }
</MudStack>

<MudButton Variant="Variant.Filled" Color="Color.Primary" OnClick="SubmitSurvey">Submit</MudButton>

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
