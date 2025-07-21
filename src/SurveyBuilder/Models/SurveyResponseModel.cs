using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SurveyBuilder.Models
{
    public class SurveyResponseModel
    {
        public string SurveyId { get; set; } = string.Empty;

        // Core of the answer map
        public Dictionary<string, object> Answers { get; set; } = new();
    }
}
