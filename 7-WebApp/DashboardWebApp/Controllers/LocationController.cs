using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Microsoft.AspNet.SignalR;
using WebApplication1.Hub;

namespace WebApplication1.Controllers
{
    public class LocationController : ApiController
    {
        [Route("Location/SendLocation")]
        public void SendLocation(string make, double latitude, double longnitude, DateTime deviceTime, double speed, double rpm)
        {
            HubConnection.Send(make, latitude, longnitude, deviceTime, speed, rpm);
        }
    }
}
