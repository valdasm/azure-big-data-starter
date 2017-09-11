using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models;
using CsvHelper.Configuration;

namespace azure_patterns_big_data.Mappers
{
    public sealed class CarDashboardMapper : CsvClassMap<CarDashboardDto>
    {
        public CarDashboardMapper()
        {
            //TODO hardcoded value for CarId
            //This needs to be added as a separate column to all files
            Map(m => m.CarId).ConvertUsing(row => "1");
            Map(m => m.DeviceTime).Index(1);
            Map(m => m.Longitude).ConvertUsing(row => double.Parse(row.GetField(2).Replace('.', ',')));
            Map(m => m.Latitude).ConvertUsing(row => double.Parse(row.GetField(3).Replace('.', ',')));

            Map(m => m.EngineRpm).ConvertUsing(row => double.Parse(row.GetField(18).Replace('.', ',')));
            Map(m => m.SpeedOdb).ConvertUsing(row => double.Parse(row.GetField(25).Replace('.', ',')));

        }
    }
}
