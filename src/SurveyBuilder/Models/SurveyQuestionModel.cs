using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SurveyBuilder.Models
{
    public class SurveyQuestionModel
    {
        public string Id { get; set; } = Guid.NewGuid().ToString();
        public string Text { get; set; } = string.Empty;
        public QuestionType Type { get; set; }
        public bool Required { get; set; } = false;
        public List<string>? Options { get; set; }
    }

}
