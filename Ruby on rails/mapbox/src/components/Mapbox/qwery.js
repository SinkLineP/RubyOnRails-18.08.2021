import React, { useEffect, useRef, useState } from 'react';
import mapboxgl from 'mapbox-gl';
import './mapbox.scss';
import 'mapbox-gl/dist/mapbox-gl.css';

mapboxgl.accessToken = 'pk.eyJ1Ijoic2lua2xpbmUiLCJhIjoiY2tmb3ljdjc0MDVxODMxbXQ0b25oZ3J2cSJ9.M-K2IshZBr-L1K9ck3fkKw';

const Mapbox = () => {
    var map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v11',
      center: [38.506900, 48.917448],
      zoom: 10
    });

    map.on('load', function () {
      map.loadImage(
        'https://docs.mapbox.com/mapbox-gl-js/assets/custom_marker.png',
        // Add an image to use as a custom marker
        function (error, image) {
          if (error) throw error;
          map.addImage('custom-marker', image);

          map.addSource('places', {
            'type': 'geojson',
            'data': {
              'type': 'FeatureCollection',
              'features': [
                {
                  'type': 'Feature',
                  'properties': {
                    'description':
                      '<strong>Школа №19</strong>'
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
                      ' <strong>СШ №30</strong>'
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
                      ' <strong>СШ №12</strong>'
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
                      ' <strong>ООШ №13</strong>'
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
                      ' <strong>СШ №27</strong>'
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
                      ' <strong>СШ Школа №2</strong>'
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
                      ' <strong>Лисичанская средняя общеобразовательная школа I-III ступеней № 9</strong>'
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
                      ' <strong>Школа №8</strong>'
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
                      ' <strong>Общеобразовательная школа № 14</strong>'
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
                      ' <strong>Школа №20</strong>'
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
                      ' <strong>Школа №16</strong>'
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
                      ' <strong>Школа №4</strong>'
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
                      ' <strong>Общеобразовательная школа №15</strong>'
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
                      ' <strong>Школа-коллегиум Киево-Могилянской академии</strong>'
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
                      ' <strong>Общеобразовательная школа №10</strong>'
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
                      ' <strong>Специализированная школа № 17</strong>'
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
                      ' <strong>СОШ №8</strong>'
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
                      ' <strong>Общеобразовательная школа №1</strong>'
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
                      ' <strong>Общеобразовательная школа №13</strong>'
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
                      ' <strong>Общеобразовательная школа №13</strong>'
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
                      ' <strong>Средняя общеобразовательная школа №12</strong>'
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
                      ' <strong>Общеобразовательная школа № 6</strong>'
                  },
                  'geometry': {
                    'type': 'Point',
                    'coordinates': [38.494369, 48.937695]
                  }
                },
              ]
            }
          });

          // Add a layer showing the places.
          map.addLayer({
            'id': 'places',
            'type': 'symbol',
            'source': 'places',
            'layout': {
              'icon-image': 'custom-marker',
              'icon-allow-overlap': true
            }
          });
        }
      );

      // Create a popup, but don't add it to the map yet.
      var popup = new mapboxgl.Popup({
        closeButton: false,
        closeOnClick: false
      });

      map.on('mouseenter', 'places', function (e) {
        // Change the cursor style as a UI indicator.
        map.getCanvas().style.cursor = 'pointer';

        var coordinates = e.features[0].geometry.coordinates.slice();
        var description = e.features[0].properties.description;

        // Ensure that if the map is zoomed out such that multiple
        // copies of the feature are visible, the popup appears
        // over the copy being pointed to.
        while (Math.abs(e.lngLat.lng - coordinates[0]) > 180) {
          coordinates[0] += e.lngLat.lng > coordinates[0] ? 360 : -360;
        }

        // Populate the popup and set its coordinates
        // based on the feature found.
        popup.setLngLat(coordinates).setHTML(description).addTo(map);
      });

      map.on('mouseleave', 'places', function () {
        map.getCanvas().style.cursor = '';
        popup.remove();
      });
    });

    return (
      <div className="mp container">
        <div className="mp-size" id="maps" ref={mapboxContainer} />
      </div>

    );



};

export default Mapbox;
