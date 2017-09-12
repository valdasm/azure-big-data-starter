using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using azure_patterns_big_data.Mappers;
using Models;
using CsvHelper;
using Microsoft.VisualBasic.FileIO;

namespace azure_patterns_big_data.Utils
{
    public class LogReader
    {
        public List<T> FileToDto<T>(string path, string delimeter = ",", bool hasHeader = true)
        {
            var events = new List<T>();

            using (var csvReader = File.OpenText(path))
            {
                var csv = new CsvReader(csvReader);
                csv.Configuration.Delimiter = delimeter;
                csv.Configuration.HasHeaderRecord = hasHeader;

                csv.Configuration.RegisterClassMap(typeof (CarEventsMapper));
                csv.Configuration.RegisterClassMap(typeof(CarDashboardMapper));

                while (csv.Read())
                {
                    var record = csv.GetRecord<T>();
                    events.Add(record);
                }
               
            }

            return events;
        }

        

    }
}
