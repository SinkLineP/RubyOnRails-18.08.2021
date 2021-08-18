import React, { useEffect, useRef, useState } from 'react';
import mapboxgl, { Marker } from "mapbox-gl";
import './mapbox.scss';
import 'mapbox-gl/dist/mapbox-gl.css';

mapboxgl.accessToken = 'pk.eyJ1Ijoic2lua2xpbmUiLCJhIjoiY2tmb3ljdjc0MDVxODMxbXQ0b25oZ3J2cSJ9.M-K2IshZBr-L1K9ck3fkKw';



    var geojson = {
      'type': 'FeatureCollection',
      'features': [
        {
          'type': 'Feature',
          'properties': {
            'description':
              '<strong>Школа №19</strong>',
            'iconSize': [25, 25]
          },
          'geometry': {
            'type': 'Point',
            'coordinates': [38.55265349, 48.86664858]
          }
        },
        {
          'type': 'Feature',
          'properties': {
            'description':
              ' <strong>СШ №30</strong>',
              'iconSize': [25, 25]
          },
          'geometry': {
            'type': 'Point',
            'coordinates': [38.485010, 48.858866]
          }
        },
        {
          'type': 'Feature',
          'properties': {
            'description':
              ' <strong>СШ №12</strong>',
              'iconSize': [25, 25]
          },
          'geometry': {
            'type': 'Point',
            'coordinates': [38.484152, 48.862072]
          }
        },
        {
          'type': 'Feature',
          'properties': {
            'description':
              ' <strong>ООШ №13</strong>',
              'iconSize': [25, 25]
          },
          'geometry': {
            'type': 'Point',
            'coordinates': [38.475247, 48.861239]
          }
        },
        {
          'type': 'Feature',
          'properties': {
            'description':
              ' <strong>СШ №27</strong>',
              'iconSize': [25, 25]
          },
          'geometry': {
            'type': 'Point',
            'coordinates': [38.484130, 48.864726]
          }
        },
        {
          'type': 'Feature',
          'properties': {
            'description':
              ' <strong>СШ Школа №2</strong>',
              'iconSize': [25, 25]
          },
          'geometry': {
            'type': 'Point',
            'coordinates': [38.469313, 48.882135]
          }
        },
        {
          'type': 'Feature',
          'properties': {
            'description':
              ' <strong>Лисичанская средняя общеобразовательная школа I-III ступеней № 9</strong>',
              'iconSize': [25, 25]
          },
          'geometry': {
            'type': 'Point',
            'coordinates': [38.436339, 48.909119]
          }
        },
        {
          'type': 'Feature',
          'properties': {
            'description':
              ' <strong>Школа №8</strong>',
              'iconSize': [25, 25]
          },
          'geometry': {
            'type': 'Point',
            'coordinates': [38.425819, 48.916833]
          }
        },
        {
          'type': 'Feature',
          'properties': {
            'description':
              ' <strong>Общеобразовательная школа № 14</strong>',
              'iconSize': [25, 25]
          },
          'geometry': {
            'type': 'Point',
            'coordinates': [38.530362, 48.944903]
          }
        },
        {
          'type': 'Feature',
          'properties': {
            'description':
              ' <strong>Школа №20</strong>',
              'iconSize': [25, 25]
          },
          'geometry': {
            'type': 'Point',
            'coordinates': [38.531877, 48.944112]
          }
        },
        {
          'type': 'Feature',
          'properties': {
            'description':
              ' <strong>Школа №16</strong>',
              'iconSize': [25, 25]
          },
          'geometry': {
            'type': 'Point',
            'coordinates': [38.520701, 48.946289]
          }
        },
        {
          'type': 'Feature',
          'properties': {
            'description':
              ' <strong>Школа №4</strong>',
              'iconSize': [25, 25]
          },
          'geometry': {
            'type': 'Point',
            'coordinates': [38.520170, 48.944873]
          }
        },
        {
          'type': 'Feature',
          'properties': {
            'description':
              ' <strong>Общеобразовательная школа №15</strong>',
              'iconSize': [25, 25]
          },
          'geometry': {
            'type': 'Point',
            'coordinates': [38.497972, 48.944873]
          }
        },
        {
          'type': 'Feature',
          'properties': {
            'description':
              ' <strong>Школа-коллегиум Киево-Могилянской академии</strong>',
              'iconSize': [25, 25]
          },
          'geometry': {
            'type': 'Point',
            'coordinates': [38.492484, 48.949523]
          }
        },
        {
          'type': 'Feature',
          'properties': {
            'description':
              ' <strong>Общеобразовательная школа №10</strong>',
              'iconSize': [25, 25]
          },
          'geometry': {
            'type': 'Point',
            'coordinates': [38.494592, 48.954871]
          }
        },
        {
          'type': 'Feature',
          'properties': {
            'description':
              ' <strong>Специализированная школа № 17</strong>',
              'iconSize': [25, 25]
          },
          'geometry': {
            'type': 'Point',
            'coordinates': [38.521225, 48.938625]
          }
        },
        {
          'type': 'Feature',
          'properties': {
            'description':
              ' <strong>СОШ №8</strong>',
              'iconSize': [25, 25]
          },
          'geometry': {
            'type': 'Point',
            'coordinates': [38.517342, 48.936848]
          }
        },
        {
          'type': 'Feature',
          'properties': {
            'description':
              ' <strong>Общеобразовательная школа №1</strong>',
              'iconSize': [25, 25]
          },
          'geometry': {
            'type': 'Point',
            'coordinates': [38.485073, 48.946318]
          }
        },
        {
          'type': 'Feature',
          'properties': {
            'description':
              ' <strong>Общеобразовательная школа №13</strong>',
              'iconSize': [25, 25]
          },
          'geometry': {
            'type': 'Point',
            'coordinates': [38.503339, 48.939532]
          }
        },
        {
          'type': 'Feature',
          'properties': {
            'description':
              ' <strong>Общеобразовательная школа №13</strong>',
              'iconSize': [25, 25]
          },
          'geometry': {
            'type': 'Point',
            'coordinates': [38.503339, 48.939532]
          }
        },
        {
          'type': 'Feature',
          'properties': {
            'description':
              ' <strong>Средняя общеобразовательная школа №12</strong>',
              'iconSize': [25, 25]
          },
          'geometry': {
            'type': 'Point',
            'coordinates': [38.492772, 48.940269]
          }
        },
        {
          'type': 'Feature',
          'properties': {
            'description':
              ' <strong>Общеобразовательная школа № 6</strong>',
              'iconSize': [25, 25]
          },
          'geometry': {
            'type': 'Point',
            'coordinates': [38.494369, 48.937695]
          }
        }
      ]
    };

    const Mapbox = () => {
      const mapContainer = useRef(null);
      const [locationInfo] = useState({
        lng: 38.484737,
        lat: 48.907107,
        zoom: 11
      });
      useEffect(() => {
        const map = new mapboxgl.Map({
          container: mapContainer.current,
          style: 'mapbox://styles/mapbox/outdoors-v11',
          center: [locationInfo.lng, locationInfo.lat],
          zoom: locationInfo.zoom
        });
    
    // add markers to map
    geojson.features.forEach(function (marker) {
      // create a DOM element for the marker
      var el = document.createElement('div');
      el.className = 'marker-icon';
      // el.style.backgroundImage = `url(../../assets/map_icon2.svg)`
      // el.style.backgroundImage =
      //   'url(https://placekitten.com/g/' +
      //   marker.properties.iconSize.join('/') +
      //   '/)';
      el.style.width = marker.properties.iconSize[0] + 'px';
      el.style.height = marker.properties.iconSize[1] + 'px';

      el.addEventListener('click', function () {
        window.alert(marker.properties.message);
      });

      // add marker to map
      new mapboxgl.Marker(el)
        .setLngLat(marker.geometry.coordinates)
        .addTo(map);
    });
  }, []);

  return (
    <section className="maps" id="maps">
      <div className="">
        <p className="headers">Школи та контакти</p>
        <div className="maps-map" ref={mapContainer} />
      </div>
    </section>
  );
};

export default Mapbox;




// import React, { useEffect, useRef, useState } from "react";
// import mapboxgl, { Marker } from "mapbox-gl";
// import "./mapbox.scss";
// import "mapbox-gl/dist/mapbox-gl.css";
// // import Mapbox from "./qwery";
// //added a link to my map
// mapboxgl.accessToken =
//   "pk.eyJ1IjoiY3IwdzFleXkiLCJhIjoiY2tmcDAzNzluMGQydDJ5cGEydnVjdHN0aiJ9.s7CUaCjhKQvH1P9zkqzjKw";

// 	var geojson = {
//           'type': 'FeatureCollection',
//           'features': [
//             {
//               'type': 'Feature',
//               'properties': {
//                 'description':
//                   '<strong>Школа №19</strong>',
//                 'iconSize': [25, 25]
//               },
//               'geometry': {
//                 'type': 'Point',
//                 'coordinates': [38.55265349, 48.86664858]
//               }
//             },
//             {
//               'type': 'Feature',
//               'properties': {
//                 'description':
//                   ' <strong>СШ №30</strong>',
//                   'iconSize': [25, 25]
//               },
//               'geometry': {
//                 'type': 'Point',
//                 'coordinates': [38.485010, 48.858866]
//               }
//             },
//             {
//               'type': 'Feature',
//               'properties': {
//                 'description':
//                   ' <strong>СШ №12</strong>',
//                   'iconSize': [25, 25]
//               },
//               'geometry': {
//                 'type': 'Point',
//                 'coordinates': [38.484152, 48.862072]
//               }
//             },
//             {
//               'type': 'Feature',
//               'properties': {
//                 'description':
//                   ' <strong>ООШ №13</strong>',
//                   'iconSize': [25, 25]
//               },
//               'geometry': {
//                 'type': 'Point',
//                 'coordinates': [38.475247, 48.861239]
//               }
//             },
//             {
//               'type': 'Feature',
//               'properties': {
//                 'description':
//                   ' <strong>СШ №27</strong>',
//                   'iconSize': [25, 25]
//               },
//               'geometry': {
//                 'type': 'Point',
//                 'coordinates': [38.484130, 48.864726]
//               }
//             },
//             {
//               'type': 'Feature',
//               'properties': {
//                 'description':
//                   ' <strong>СШ Школа №2</strong>',
//                   'iconSize': [25, 25]
//               },
//               'geometry': {
//                 'type': 'Point',
//                 'coordinates': [38.469313, 48.882135]
//               }
//             },
//             {
//               'type': 'Feature',
//               'properties': {
//                 'description':
//                   ' <strong>Лисичанская средняя общеобразовательная школа I-III ступеней № 9</strong>',
//                   'iconSize': [25, 25]
//               },
//               'geometry': {
//                 'type': 'Point',
//                 'coordinates': [38.436339, 48.909119]
//               }
//             },
//             {
//               'type': 'Feature',
//               'properties': {
//                 'description':
//                   ' <strong>Школа №8</strong>',
//                   'iconSize': [25, 25]
//               },
//               'geometry': {
//                 'type': 'Point',
//                 'coordinates': [38.425819, 48.916833]
//               }
//             },
//             {
//               'type': 'Feature',
//               'properties': {
//                 'description':
//                   ' <strong>Общеобразовательная школа № 14</strong>',
//                   'iconSize': [25, 25]
//               },
//               'geometry': {
//                 'type': 'Point',
//                 'coordinates': [38.530362, 48.944903]
//               }
//             },
//             {
//               'type': 'Feature',
//               'properties': {
//                 'description':
//                   ' <strong>Школа №20</strong>',
//                   'iconSize': [25, 25]
//               },
//               'geometry': {
//                 'type': 'Point',
//                 'coordinates': [38.531877, 48.944112]
//               }
//             },
//             {
//               'type': 'Feature',
//               'properties': {
//                 'description':
//                   ' <strong>Школа №16</strong>',
//                   'iconSize': [25, 25]
//               },
//               'geometry': {
//                 'type': 'Point',
//                 'coordinates': [38.520701, 48.946289]
//               }
//             },
//             {
//               'type': 'Feature',
//               'properties': {
//                 'description':
//                   ' <strong>Школа №4</strong>',
//                   'iconSize': [25, 25]
//               },
//               'geometry': {
//                 'type': 'Point',
//                 'coordinates': [38.520170, 48.944873]
//               }
//             },
//             {
//               'type': 'Feature',
//               'properties': {
//                 'description':
//                   ' <strong>Общеобразовательная школа №15</strong>',
//                   'iconSize': [25, 25]
//               },
//               'geometry': {
//                 'type': 'Point',
//                 'coordinates': [38.497972, 48.944873]
//               }
//             },
//             {
//               'type': 'Feature',
//               'properties': {
//                 'description':
//                   ' <strong>Школа-коллегиум Киево-Могилянской академии</strong>',
//                   'iconSize': [25, 25]
//               },
//               'geometry': {
//                 'type': 'Point',
//                 'coordinates': [38.492484, 48.949523]
//               }
//             },
//             {
//               'type': 'Feature',
//               'properties': {
//                 'description':
//                   ' <strong>Общеобразовательная школа №10</strong>',
//                   'iconSize': [25, 25]
//               },
//               'geometry': {
//                 'type': 'Point',
//                 'coordinates': [38.494592, 48.954871]
//               }
//             },
//             {
//               'type': 'Feature',
//               'properties': {
//                 'description':
//                   ' <strong>Специализированная школа № 17</strong>',
//                   'iconSize': [25, 25]
//               },
//               'geometry': {
//                 'type': 'Point',
//                 'coordinates': [38.521225, 48.938625]
//               }
//             },
//             {
//               'type': 'Feature',
//               'properties': {
//                 'description':
//                   ' <strong>СОШ №8</strong>',
//                   'iconSize': [25, 25]
//               },
//               'geometry': {
//                 'type': 'Point',
//                 'coordinates': [38.517342, 48.936848]
//               }
//             },
//             {
//               'type': 'Feature',
//               'properties': {
//                 'description':
//                   ' <strong>Общеобразовательная школа №1</strong>',
//                   'iconSize': [25, 25]
//               },
//               'geometry': {
//                 'type': 'Point',
//                 'coordinates': [38.485073, 48.946318]
//               }
//             },
//             {
//               'type': 'Feature',
//               'properties': {
//                 'description':
//                   ' <strong>Общеобразовательная школа №13</strong>',
//                   'iconSize': [25, 25]
//               },
//               'geometry': {
//                 'type': 'Point',
//                 'coordinates': [38.503339, 48.939532]
//               }
//             },
//             {
//               'type': 'Feature',
//               'properties': {
//                 'description':
//                   ' <strong>Общеобразовательная школа №13</strong>',
//                   'iconSize': [25, 25]
//               },
//               'geometry': {
//                 'type': 'Point',
//                 'coordinates': [38.503339, 48.939532]
//               }
//             },
//             {
//               'type': 'Feature',
//               'properties': {
//                 'description':
//                   ' <strong>Средняя общеобразовательная школа №12</strong>',
//                   'iconSize': [25, 25]
//               },
//               'geometry': {
//                 'type': 'Point',
//                 'coordinates': [38.492772, 48.940269]
//               }
//             },
//             {
//               'type': 'Feature',
//               'properties': {
//                 'description':
//                   ' <strong>Общеобразовательная школа № 6</strong>',
//                   'iconSize': [25, 25]
//               },
//               'geometry': {
//                 'type': 'Point',
//                 'coordinates': [38.494369, 48.937695]
//               }
//             },
//           ]
//         };

// const Mapbox = () => {
//   const mapContainer = useRef(null);
//   //locationInfo
//   const [locationInfo] = useState({
//     lng: 31,
//     lat: 48.3,
//     zoom: 5,
//   });
//   //add useEffect
//   useEffect(() => {
//     const map = new mapboxgl.Map({
//       container: mapContainer.current,
//       style: "mapbox://styles/mapbox/outdoors-v11",
//       center: [locationInfo.lng, locationInfo.lat],
//       zoom: locationInfo.zoom,
//       pitch: 45,
//       bearing: 17.6,
// 		});
		
		

//     geojson.features.forEach(function (marker) {
// 			// create a DOM element for the marker
// 			var el = document.createElement('div');
// 			el.className = 'marker';
// 			el.style.backgroundImage =
// 			// `url(./image/student.svg)`
// 			'url(https://www.flaticon.com/svg/static/icons/svg/1673/1673188.svg)';
// 			// el.style.width = marker.properties.iconSize[0] + 'px';
// 			// el.style.height = marker.properties.iconSize[1] + 'px';
			 
// 			el.addEventListener('click', function () {
// 			window.alert(marker.properties.message);
// 			});
			 
// 			// add marker to map
// 			new mapboxgl.Marker(el)
// 			.setLngLat(marker.geometry.coordinates)
// 			.addTo(map);
// 			});

//     var nav = new mapboxgl.NavigationControl();
//     map.addControl(nav, "top-left");

//     map.addControl(
//       new mapboxgl.GeolocateControl({
//         positionOptions: {
//           enableHighAccuracy: true,
//         },
//         trackUserLocation: true,
//       })
//     );

//     var scale = new mapboxgl.ScaleControl({
//       maxWidth: 80,
//       unit: "imperial",
//     });
//     map.addControl(scale);

//     scale.setUnit("metric");
//   }, []);
//   //name classes air-q
//   return (
//     <section className="air-q container" id="maps">
//       <h2 className="air-q-title" id="quality">
//         Индекс качества воздуха в режиме реального времени
//       </h2>

//       <div className="air-q-map" ref={mapContainer} />

//       <p className="air-q-text">
//         Для того чтобы узнать уровень загрязнения атмосферного воздуха (качество
//         воздуха) в городе Киев, необходимо выбрать соответствующую станцию
//         мониторинга на карте выше.
//       </p>
//     </section>
//   );
// };

// export default Mapbox;
