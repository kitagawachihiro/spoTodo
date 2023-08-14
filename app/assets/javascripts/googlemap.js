let map

function initMap() {

    map = new google.maps.Map(document.getElementById("map"), {
        center: {lat:35.6594666, lng: 139.7005536},
        zoom: 16
    });
  }


function getAddress() {

    var input = document.getElementById("spot_name").value;
    
    var request = {
        query: input,
        fields: ['name', 'geometry', 'formatted_address'],
      };
    
      var service = new google.maps.places.PlacesService(map);

      service.findPlaceFromQuery(request, function(results, status) {
        if (status === google.maps.places.PlacesServiceStatus.OK) {
            map.setCenter(results[0].geometry.location);
            let marker = new google.maps.Marker({
              map: map,
              position: results[0].geometry.location,
            });

          document.getElementById("spot_name").value = results[0].name
          document.getElementById("spot_address").value = results[0].formatted_address
          document.getElementById("spot_lat").value  = results[0].geometry.location.lat();
          document.getElementById("spot_lon").value  = results[0].geometry.location.lng();
          
        }else if(status === google.maps.places.PlacesServiceStatus.ZERO_RESULTS) {
            alert('別のワードで検索してください');
        }else if(status === google.maps.places.PlacesServiceStatus.INVALID_REQUEST) {
        }else{
            alert('サービスで問題発生しているため、現在使用できません。' + status);
        }
      });

  }


  $(function(){
    $('.get-current-position-btn').click(function(){
    const currentPosition = navigator.geolocation.getCurrentPosition(success,fail);
    });
  });


// 成功時の処理 
function success(position) {

     const lat = position.coords.latitude;
     const lng = position.coords.longitude;
     const token = $('meta[name="csrf-token"]').attr('content');
     
    $.ajax({
    url: '/currentlocation/create',
    type: "POST",
    headers: {'X-CSRF-Token' : token },
    data: {
      latitude: lat,
      longitude: lng
    },
    success: function(data) {
      alert("現在地を取得しました");
    },
    error: function(data) {
      alert("現在地を取得できませんでした");
    }
  });
}
            
// 失敗時の処理 
 function fail(position){
   alert('位置情報の取得に失敗しました。');
 }



  


