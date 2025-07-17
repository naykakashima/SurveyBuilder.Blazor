using SurveyBuilder.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SurveyBuilder.Services
{
    public interface ISurveyJsonService
    {
        string Serialize(SurveyModel survey);
        SurveyModel Deserialize(string json);
    }

}
