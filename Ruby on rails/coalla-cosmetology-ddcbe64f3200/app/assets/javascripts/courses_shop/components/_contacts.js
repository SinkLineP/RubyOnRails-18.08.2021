var contactsMap1;
var contactsMap2;
var contactsMap3;

function init() {
    contactsMap1 = new ymaps.Map('contacts-map-1', {
        center: [55.759735, 37.656003],
        zoom: 16
    });
    contactsMap1.geoObjects.add(new ymaps.Placemark([55.760373, 37.651699], {}, {
        preset: 'islands#redIcon'
    }));

    contactsMap2 = new ymaps.Map('contacts-map-2', {
        center: [55.757727, 37.640532],
        zoom: 15
    });
    contactsMap2.geoObjects.add(new ymaps.Placemark([55.760373, 37.651699], {}, {
        preset: 'islands#redIcon'
    }));

    contactsMap3 = new ymaps.Map('contacts-map-3', {
        center: [55.762822, 37.643718],
        zoom: 16
    });
    contactsMap3.geoObjects.add(new ymaps.Placemark([55.760373, 37.651699], {}, {
        preset: 'islands#redIcon'
    }));
}

if (Modernizr.mq(BREAKPOINT_DESKTOP)) {
    ymaps.ready(init);
}