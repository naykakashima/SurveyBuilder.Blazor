using SurveyBuilder.Models;

namespace SurveyBuilder.DemoApp.Components.Infrastructure
{
    public interface ISurveyRepository
    {
        List<SurveyModel> GetAll();
        SurveyModel? GetById(string id);
        void Add(SurveyModel survey);
        void Update(SurveyModel survey);
        void Delete(string id);
    }

}
