using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models
{
    public class CarDashboardDto
    {
        public string CarId { get; set; }
        public DateTime DeviceTime { get; set; }
        public string Make { get; set; }
        public double Longitude { get; set; }
        public double Latitude { get; set; }
        public double EngineRpm { get; set; }
        public double SpeedOdb { get; set; }

        public override string ToString()
        {
            return "Time: " + DeviceTime + "; Latitude: " + Latitude + "; Longitude: " + Longitude;
        }
    }
}
