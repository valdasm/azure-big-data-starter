using Microsoft.ServiceBus.Messaging;
using Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Diagnostics;
using System.Linq;
using System.Web;

namespace WebApplication1.Hub
{
    public class ServiceBusQueueHub
    {

        public static void Register()
        {
            QueueClient _queueClient;

            var queueConnectionString = ConfigurationManager.AppSettings["ServiceBusConnectionString"];
            var queueName = ConfigurationManager.AppSettings["ServiceBusQueueName"];

            _queueClient = QueueClient.CreateFromConnectionString(queueConnectionString, queueName);

            _queueClient.OnMessage((message) =>
            {
                try
                {
                    // Process message from queue
                    Trace.WriteLine("Message received: " + ((BrokeredMessage)message).Label);

                    var json = message.GetBody<string>();
                    var deserialized = JsonConvert.DeserializeObject<CarDashboardDto>(json);
                    
                    HubConnection.Send(deserialized.Latitude, deserialized.Longitude, deserialized.DeviceTime, deserialized.SpeedOdb, deserialized.EngineRpm);
                    message.Complete();


                }
                catch (Exception ex)
                {
                    // Indicates a problem, unlock message in queue
                    Trace.WriteLine("Exception: " + ex.Message);
                    message.Abandon();
                }
            });
        }
    }
}