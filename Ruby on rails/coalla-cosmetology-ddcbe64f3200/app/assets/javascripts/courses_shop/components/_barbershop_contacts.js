var contactsMap1;
var contactsMap2;
var pointA1 = "метро Павелецкая",
  pointA2 = "метро Новокузнецкая",
  pointB = "Большая Татарская улица, 35с3";
function init() {
  multiRoute1 = new ymaps.multiRouter.MultiRoute(
    {
      referencePoints: [pointA1, pointB],
      params: {
        //Тип маршрутизации - пешеходная маршрутизация.
        routingMode: "pedestrian"
      }
    },
    {
      // Автоматически устанавливать границы карты так, чтобы маршрут был виден целиком.
      boundsAutoApply: true,
      zoomMargin: 30
    }
  );
  multiRoute2 = new ymaps.multiRouter.MultiRoute(
    {
      referencePoints: [pointA2, pointB],
      params: {
        //Тип маршрутизации - пешеходная маршрутизация.
        routingMode: "pedestrian"
      }
    },
    {
      // Автоматически устанавливать границы карты так, чтобы маршрут был виден целиком.
      boundsAutoApply: true
    }
  );
  contactsMap1 = new ymaps.Map("contacts-map-1", {
    center: [55.73411, 37.636198],
    zoom: 14
  });
  contactsMap1.geoObjects.add(multiRoute1);

  contactsMap2 = new ymaps.Map("contacts-map-2", {
    center: [55.739681, 37.631532],
    zoom: 14
  });
  contactsMap2.geoObjects.add(multiRoute2);

  contactsMap1.controls.remove("searchControl");
  contactsMap2.controls.remove("searchControl");
}

if (Modernizr.mq(BREAKPOINT_DESKTOP)) {
  ymaps.ready(init);
}
