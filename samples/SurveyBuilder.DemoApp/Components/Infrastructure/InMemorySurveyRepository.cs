using SurveyBuilder.DemoApp.Components.Infrastructure;
using SurveyBuilder.Models;
using System.Xml.Linq;

public class InMemorySurveyRepository : ISurveyRepository
{
    private readonly List<SurveyModel> _surveys = new();

    public List<SurveyModel> GetAll() => _surveys;

    public SurveyModel? GetById(string id) =>
        _surveys.FirstOrDefault(s => s.Id == id);

    public void Add(SurveyModel survey)
    {
        _surveys.Add(survey);
    }

    public void Update(SurveyModel survey)
    {
        var index = _surveys.FindIndex(s => s.Id == survey.Id);
        if (index >= 0)
            _surveys[index] = survey;
    }

    public void Delete(string id)
    {
        var survey = GetById(id);
        if (survey is not null)
            _surveys.Remove(survey);
    }
}
