var $careerAfterCoursesDocumentsSlider = $('#career-after-courses-documents-slider');
var $careerAfterCoursesDocumentsItem = $('.js-career-after-courses-documents-item');

function careerAfterCoursesDocumentsSliderInit() {
    if ($careerAfterCoursesDocumentsSlider.length) {
        $('#career-after-courses-documents-slider-prev').on('click', function () {
            $careerAfterCoursesDocumentsSlider.slick('slickPrev');

            return false;
        });

        $('#career-after-courses-documents-slider-next').on('click', function () {
            $careerAfterCoursesDocumentsSlider.slick('slickNext');

            return false;
        });

        $careerAfterCoursesDocumentsSlider.slick({
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
    if (Modernizr.mq(BREAKPOINT_MOBILE)) {
        if ($careerAfterCoursesDocumentsItem.length > 1) {
            careerAfterCoursesDocumentsSliderInit();
        }
    } else {
        if ($careerAfterCoursesDocumentsItem.length > 3) {
            careerAfterCoursesDocumentsSliderInit();
        }
    }
});