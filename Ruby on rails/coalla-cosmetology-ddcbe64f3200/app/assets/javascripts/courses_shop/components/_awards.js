var $awardsSlider = $('#awards-slider');

function awardsSliderInit() {
    if ($awardsSlider.length) {
        $awardsSlider.slick({
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
                        autoplay: true,
                        autoplaySpeed: 3000,
                        slidesToShow: 3,
                        slidesToScroll: 3
                    }
                }
            ],
            speed: BASE_TRANSITION_DURATION
        });
    }
}

$(window).load(function() {
    awardsSliderInit();
});