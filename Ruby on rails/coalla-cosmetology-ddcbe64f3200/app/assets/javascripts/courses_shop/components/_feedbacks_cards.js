var $feedbacksCardsSlider = $('#feedbacks-cards-slider');

function feedbacksCardsSliderInit() {
    if ($feedbacksCardsSlider.length) {
        $feedbacksCardsSlider.slick({
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
    }
}

$(window).load(function() {
    feedbacksCardsSliderInit();
});