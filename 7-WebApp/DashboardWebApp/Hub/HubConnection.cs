using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.SignalR;
using Microsoft.AspNet.SignalR.Hubs;

namespace WebApplication1.Hub
{
    public class HubConnection : Microsoft.AspNet.SignalR.Hub
    {
        public static void Send(double lat, double lng, DateTime deviceTime, double speed, double rpm)
        {
            var hub = GlobalHost.ConnectionManager.GetHubContext<HubConnection>();
            hub.Clients.All.SendLocation(lat, lng, deviceTime.ToString(), speed.ToString("0.##"), rpm.ToString("0.##"));
            
        }
    }
}