if (typeof(window.console) == "undefined") { console = {}; console.log = console.warn = console.error = function(a) {}; }

$(function () {
  function initialize() {
    var graph_data = JSON.parse($('#graph_data').html());
    for ( var i = 0; i < graph_data.length; ++i ) {
        var tmp = graph_data[i][1];
        graph_data[i][1] = parseFloat(graph_data[i][2]);
        graph_data[i][2] = parseFloat(tmp);
    }
    console.log(graph_data);

    var myOptions = {
      zoom: 8,
      center: new google.maps.LatLng(35.681382, 139.766084),
      mapTypeId: google.maps.MapTypeId.ROADMAP
      };
    var map = new google.maps.Map(document.getElementById("map_canvas"),myOptions);
    var markers = graph_data;
    for (var i = 0; i < markers.length; i++) {
      var name = markers[i][0];
      var latlng = new google.maps.LatLng(markers[i][1],markers[i][2]);
      createMarker(name,latlng,map);
      }
  }
  function createMarker(name,latlng,map){
    var infoWindow = new google.maps.InfoWindow();
    var marker = new google.maps.Marker({position: latlng,map: map});
    google.maps.event.addListener(marker, 'click', function() {
        infoWindow.setContent(name);
        infoWindow.open(map,marker);
        });
  }
  google.maps.event.addDomListener(window, 'load', initialize);
});
