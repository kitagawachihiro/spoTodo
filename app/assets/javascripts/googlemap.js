 let map;
 var marker = [];
 var infoWindow = [];
 var markerData = [];

function getPlace() {
  // 初期化
  map = null;
  infoWindow = [];
  markerData = [];
  marker = [];

  const input = document.getElementById("spot_name").value;
  const token = $('meta[name="csrf-token"]').attr("content");

  const data = {
      textQuery: input
    };

  fetch('/http_post', {
      method: 'POST',
      headers: {
          'Content-Type': 'application/json',
          "X-CSRF-Token": token,
      },
      body: JSON.stringify(data)
  })
  .then(response => response.json())

  .then(data => {
      if (data.success) {
            for (var i = 0; i < data.data.places.length; i++) {
              markerData.push({
                name: data.data.places[i].displayName.text,
                lat: data.data.places[i].location.latitude,
                lng: data.data.places[i].location.longitude,
                address: data.data.places[i].formattedAddress
              });
            };
        loadGoogleMapsScript(data.apikey);
      } else {
          alert("入力してから検索ボタンを押してください");
          console.error('Error:', data.error);
      }
  })
  .catch(error => {
      console.error('Error:', error);
  });
}


// Google Maps APIの読み込み状態を保持するPromise
let mapLoadedPromise = null;

// 非同期でGoogle Maps APIスクリプトを読み込む関数
function loadGoogleMapsScript(apikey) {
  if (!mapLoadedPromise) {
    mapLoadedPromise = new Promise((resolve) => {
      const script = document.createElement("script"); 
      script.src = `https://maps.googleapis.com/maps/api/js?key=${apikey}&libraries=places&callback=initMap`;
      script.async = true;
      script.defer = true;
      document.body.appendChild(script);
      script.onload = resolve;
    });
  }else{
    initMap();
  }
  
  return mapLoadedPromise;
}

// 他の関数からGoogle Maps APIを使用するためのサンプル関数
// function useGoogleMapsAPI() {
//   loadGoogleMapsScript().then(() => {
//     initMap(); 
//   });
// }



function initMap() {

    const mapDiv = document.getElementById('map');
    map = new google.maps.Map(mapDiv, {
      center: ({lat: markerData[0].lat, lng: markerData[0].lng}),
      zoom: 14
    });

    if (markerData.length >= 1){
    // マーカー毎の処理
      for (var i = 0; i < markerData.length; i++) {
        markerLatLng = {lat: markerData[i]['lat'], lng: markerData[i]['lng']}; // 緯度経度のデータ作成
        marker[i] = new google.maps.Marker({ // マーカーの追加
          position: markerLatLng, // マーカーを立てる位置を指定
          map: map // マーカーを立てる地図を指定
        });

        infoWindow[i] = new google.maps.InfoWindow({ // 吹き出しの追加
          content: '<div class="sample">' + markerData[i]['name'] + '</div>' // 吹き出しに表示する内容
        });

        markerEvent(i); // マーカーにクリックイベントを追加

        document.getElementsByClassName("result")[0].style.display ="flex";

        document.getElementById(`visible_result_name_${i}`).innerHTML =  markerData[i]['name'];
        document.getElementById(`visible_result_address_${i}`).innerHTML =  markerData[i]['address'];


        document.getElementById(`result_name_${i}`).value =  markerData[i]['name'];
        document.getElementById(`result_address_${i}`).value =  markerData[i]['address'];
        document.getElementById(`result_latitude_${i}`).value =  markerData[i]['lat'];
        document.getElementById(`result_longitude_${i}`).value =  markerData[i]['lng'];


        document.getElementsByClassName("map_submit")[0].style.display ="block";
      }
    }
}
  

  
 // マーカーにクリックイベントを追加
 function markerEvent(i) {
     marker[i].addListener('click', function() { // マーカーをクリックしたとき
       infoWindow[i].open(map, marker[i]); // 吹き出しの表示
   });
 }
 
 
 $(document).on ("turbolinks:load", function () {
    $(".get-current-position-btn").click(() => {
      navigator.geolocation.getCurrentPosition(success, fail);
    });
    });
 
 // 成功時の処理
 function success(position) {
   const lat = position.coords.latitude;
   const lng = position.coords.longitude;
   const token = $('meta[name="csrf-token"]').attr("content");
   $.ajax({
     url: "/currentlocations",
     type: "POST",
     headers: { "X-CSRF-Token": token },
     data: {
       latitude: lat,
       longitude: lng,
     },
     success: function (data) {
       alert("現在地を取得しました");
     },
     error: function (data) {
       alert("現在地を取得できませんでした");
     },
   });
 }
 
 // 失敗時の処理
 function fail(position) {
   alert(
     "位置情報の取得に失敗しました。サーバーが混み合っており、ただいまこのサービスは利用できません。"
   );
 }

 