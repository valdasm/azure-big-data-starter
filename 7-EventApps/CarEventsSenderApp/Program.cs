using System.Linq;
using azure_patterns_big_data.Mappers;
using azure_patterns_big_data.Utils;
using Models;

namespace azure_patterns_big_data
{
    class Program
    {
        static void Main(string[] args)
        {

            var logReader = new LogReader();

            var deserializedObjects = 
                logReader.FileToDto<CarEventsDto>("Data\\Ride.csv");

            var ehSender = new EventHubSender();

            ehSender.SendMessagesToEventHub(deserializedObjects.Take(1000)).GetAwaiter().GetResult();


        }
    }
}
