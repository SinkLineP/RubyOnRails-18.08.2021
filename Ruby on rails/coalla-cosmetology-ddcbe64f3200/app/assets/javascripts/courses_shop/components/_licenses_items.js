var $licensesItemsSlider = $('.js-licenses-items-slider');

function licensesItemsSliderInit() {
    if ($licensesItemsSlider.length) {
        $licensesItemsSlider.each(function() {
            $(this).slick({
                adaptiveHeight: true,
                arrows: false,
                customPaging: function() {
                    return '<span/>';
                },
                dots: true,
                draggable: false,
                infinite: true,
                mobileFirst: true,
                responsive: [
                    {
                        breakpoint: BREAKPOINT_MOBILE_INT,
                        settings: 'unslick'
                    }
                ],
                speed: BASE_TRANSITION_DURATION
            });
        })
    }
}

$(window).load(function() {
    licensesItemsSliderInit();
});