var map;
function initMap() {
    map = new google.maps.Map(document.getElementById('map'), {
        center: { lat: 54.513599, lng: 25.583993 },
        zoom: 10
    });
};

$(function () {
    // Declare a proxy to reference the hub. 
    var chat = $.connection.hubConnection;
    console.log(chat);
    // Create a function that the hub can call to broadcast messages.
    chat.client.sendLocation = function (lat, lng, time, speed, rpm) {
        new google.maps.Marker({
            position: { lat: lat, lng: lng },
            map: map,
            title: 'Hello World!'
        });
        //map.setCenter({ lat: lat, lng: lng });
        //console.log("Time: " + time);
        $('#deviceTime').text(time);
        $('#speed').text(speed);
        $('#rpm').text(rpm);
        console.log("msgRecieved");
    };

    $.connection.hub.start().done(function () {
        console.log("Connected");
    });
});