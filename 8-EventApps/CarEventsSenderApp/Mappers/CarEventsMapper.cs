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
    public sealed class CarEventsMapper : CsvClassMap<CarEventsDto>
    {
        public CarEventsMapper()
        {
            Map(m => m.CarId).Index(0);
            Map(m => m.GpsTime).Index(1);
            Map(m => m.DeviceTime).Index(2);
            Map(m => m.Longitude).ConvertUsing(row => double.Parse(row.GetField(3).Replace('.', ',')));
            Map(m => m.Latitude).ConvertUsing(row => double.Parse(row.GetField(4).Replace('.', ',')));
            Map(m => m.GpsSpeed).Index(5);
            Map(m => m.HorizontalDilution).Index(6);
            Map(m => m.Altitude).Index(7);
            Map(m => m.Bearing).Index(8);
            Map(m => m.ZeroToHundred).Index(9);
            Map(m => m.ZeroToTwoHundreds).Index(10);
            Map(m => m.OneForthMile).Index(11);
            Map(m => m.OneEightMile).Index(12);
            Map(m => m.HundredToZero).Index(13);
            Map(m => m.HundredToTwoHundred).Index(14);
            Map(m => m.EightyToOneTwenty).Index(15);
            Map(m => m.AverageTripSpeed).Index(16);
            Map(m => m.EngineCoolantTemp).Index(17);
            Map(m => m.EngineLoad).Index(18);
            Map(m => m.EngineRpm).ConvertUsing(row => double.Parse(row.GetField(19).Replace('.', ',')));
            Map(m => m.FuelCostPerTrip).Index(20);
            Map(m => m.FuelLevelFromEngine).Index(21);
            Map(m => m.FuelUsedPerTrip).Index(22);
            Map(m => m.HorsepowerHp).Index(23);
            Map(m => m.IntakeAirTemp).Index(24);
            Map(m => m.LitersPerHundredInstant).ConvertUsing(row =>
            {
                double result = 0;
                double.TryParse(row.GetField(25).Replace('.', ','), out result);
                return result;
                
            });
            Map(m => m.SpeedOdb).ConvertUsing(row => double.Parse(row.GetField(26).Replace('.', ',')));
            Map(m => m.ThrottlePosition).Index(27);
            Map(m => m.TripAvgLitersPerHundred).Index(28);
            Map(m => m.TurboBoostAndVacuum).Index(29);
        }
    }
}
