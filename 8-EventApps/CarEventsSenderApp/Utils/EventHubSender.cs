using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Azure.EventHubs;
using Newtonsoft.Json;


namespace azure_patterns_big_data.Utils
{
    public class EventHubSender
    {
        private static EventHubClient _eventHubClient;

        public EventHubSender()
        {
            var ehConnectionString = ConfigurationManager.AppSettings["EventHubConnectionString"];
            var ehName = ConfigurationManager.AppSettings["EventHubName"];

            var connectionStringBuilder = new EventHubsConnectionStringBuilder(ehConnectionString)
            {
                EntityPath = ehName
            };


            _eventHubClient = EventHubClient.CreateFromConnectionString(connectionStringBuilder.ToString());
        }

        public async Task SendMessagesToEventHub(IEnumerable messages, int delay = 1000)
        {

            foreach (var message in messages)
            {
                try
                {
                    Console.WriteLine(message);
                    var jsonMsg = JsonConvert.SerializeObject(message);
                    var eventData = new EventData(Encoding.UTF8.GetBytes(jsonMsg));
                    await _eventHubClient.SendAsync(eventData);
                    
                }
                catch (Exception exception)
                {
                    Console.WriteLine($"{DateTime.Now} > Exception: {exception.Message}");
                    Console.ReadKey();
                }

                await Task.Delay(delay);
            }

        }
    }
}
