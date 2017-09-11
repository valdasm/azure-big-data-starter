using System;
using System.Collections.Generic;
using System.Globalization;

namespace Models
{
    public class CarEventsDto
    {
        public string CarId { get; set; }
        public string GpsTime { get; set; }
        public DateTime DeviceTime { get; set; }
        public double Longitude { get; set; }
        public double Latitude { get; set; }
        public string GpsSpeed { get; set; }
        public string HorizontalDilution { get; set; }
        public string Altitude { get; set; }
        public string Bearing { get; set; }
        public string ZeroToHundred { get; set; }
        public string ZeroToTwoHundreds { get; set; }
        public string OneForthMile { get; set; }
        public string OneEightMile { get; set; }
        public string HundredToZero { get; set; }
        public string HundredToTwoHundred { get; set; }
        public string EightyToOneTwenty { get; set; }
        public string AverageTripSpeed { get; set; }
        public string EngineCoolantTemp { get; set; }
        public string EngineLoad { get; set; }
        public double EngineRpm { get; set; }
        public string FuelCostPerTrip { get; set; }
        public string FuelLevelFromEngine { get; set; }
        public string FuelUsedPerTrip { get; set; }
        public string HorsepowerHp { get; set; }
        public string IntakeAirTemp { get; set; }
        public double LitersPerHundredInstant { get; set; }
        public double SpeedOdb { get; set; }
        public string ThrottlePosition { get; set; }
        public string TripAvgLitersPerHundred { get; set; }
        public string TurboBoostAndVacuum { get; set; }

        public override string ToString()
        {
            return "Time: " + GpsTime + "; Latitude: " + Latitude + "; Longitude: " + Longitude;
        }

    }
}
