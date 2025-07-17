using SurveyBuilder.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace SurveyBuilder.Services
{
    public class SurveyJsonService : ISurveyJsonService
    {
        private readonly JsonSerializerOptions _options = new()
        {
            WriteIndented = true,
            PropertyNamingPolicy = JsonNamingPolicy.CamelCase
        };

        public string Serialize(SurveyModel survey)
        {
            return JsonSerializer.Serialize(survey, _options);
        }

        public SurveyModel Deserialize(string json)
        {
            return JsonSerializer.Deserialize<SurveyModel>(json, _options)
                   ?? new SurveyModel(); // fallback
        }
    }
}
