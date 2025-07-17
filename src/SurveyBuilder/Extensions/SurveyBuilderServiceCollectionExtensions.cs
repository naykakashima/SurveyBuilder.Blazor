using Microsoft.Extensions.DependencyInjection;
using SurveyBuilder.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SurveyBuilder.Extensions
{
    public static class SurveyBuilderServiceCollectionExtensions
    {
        public static IServiceCollection AddSurveyBuilder(this IServiceCollection services)
        {
            services.AddScoped<ISurveyJsonService, SurveyJsonService>();
            return services;
        }
    }
}
