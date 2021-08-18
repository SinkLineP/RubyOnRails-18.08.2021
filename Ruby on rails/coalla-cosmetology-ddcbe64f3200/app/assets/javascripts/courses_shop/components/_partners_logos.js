var $partnersLogosSlider = $('#partners-logos-slider');

function partnersLogosSliderInit() {
    if ($partnersLogosSlider.length) {
        $('#partners-logos-slider-prev').on('click', function () {
            $partnersLogosSlider.slick('slickPrev');

            return false;
        });

        $('#partners-logos-slider-next').on('click', function () {
            $partnersLogosSlider.slick('slickNext');

            return false;
        });

        $partnersLogosSlider.slick({
            arrows: false,
            draggable: false,
            infinite: true,
            mobileFirst: true,
            responsive: [
                {
                    breakpoint: BREAKPOINT_MOBILE_INT,
                    settings: {
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
    partnersLogosSliderInit();
});