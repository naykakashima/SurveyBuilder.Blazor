using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SurveyBuilder.Blazor.Models
{
    public enum QuestionType
    {
        SingleChoice,
        OpinionScale,
        LikertScale,
        MultiChoice,
        Dropdown,
        OpenEnded
    }

}
