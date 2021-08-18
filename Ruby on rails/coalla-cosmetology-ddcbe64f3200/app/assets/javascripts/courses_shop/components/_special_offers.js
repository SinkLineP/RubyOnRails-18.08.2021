var $specialOffersSlider = $('#special-offers-slider');

function specialOffersSliderInit() {
    if ($specialOffersSlider.length) {
        $specialOffersSlider.slick({
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
                    settings: {
                        // autoplay: true,
                        // autoplaySpeed: 3000,
                        slidesToShow: 3,
                        slidesToScroll: 3
                    }
                }
            ],
            speed: BASE_TRANSITION_DURATION
        });
    }
}

$(function() {
    specialOffersSliderInit();
});