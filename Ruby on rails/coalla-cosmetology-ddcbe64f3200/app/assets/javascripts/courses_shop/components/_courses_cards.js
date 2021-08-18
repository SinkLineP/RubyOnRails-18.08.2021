var $coursesCardsSlider = $('#courses-cards-slider');
var $courseCard = $('.js-course-card');

function coursesCardsSliderInit() {
    if ($coursesCardsSlider.length) {
        $coursesCardsSlider.slick({
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

function courseCardImagePull() {
    if (Modernizr.mq(BREAKPOINT_MOBILE)) {
        $courseCard.each(function() {
            var $this = $(this);
            var $image = $this.find('.js-course-card-image');
            var pullTop = $image.outerHeight() - $this.find('.js-course-card-meta').outerHeight();

            $image.css('margin-bottom', '-' + pullTop + 'px');
        });
    } else {
        $courseCard.each(function() {
            $(this)
                .find('.js-course-card-image')
                .css('margin-bottom', '');
        });
    }

    if ($coursesCardsSlider.hasClass('.slick-initialized')) {
        $coursesCardsSlider[0].slick.refresh(); // Refresh slider after calculations
    }
}

function courseCardHover() {
    if (Modernizr.mq(BREAKPOINT_MOBILE)) {
        $courseCard.off('mouseenter');
    } else {
        $courseCard
            .on('mouseenter', function() {
                var $this = $(this);
                var pullTop = $this.find('.js-course-card-image').outerHeight() - $this.find('.js-course-card-meta').outerHeight();

                $this.find('.js-course-card-content').stop(0).animate({'margin-top': '-' + pullTop + 'px'}, BASE_TRANSITION_DURATION);
            })
            .on('mouseleave', function() {
                $(this).find('.js-course-card-content').stop(0).animate({'margin-top': ''}, BASE_TRANSITION_DURATION);
            });
    }
}

function courseCardHeight() {
    if (Modernizr.mq(BREAKPOINT_MOBILE)) {
        $courseCard.each(function() {
            $(this).css('height', '');
        });
    } else {
        $courseCard.each(function() {
            var $this = $(this);

            $this
                .css('height', '')
                .css('height', $this.outerHeight());
        });
    }
}

$(window)
    .load(function() {
        coursesCardsSliderInit();
        courseCardImagePull();
        courseCardHover();
        courseCardHeight();
    })
    .smartresize(function() {
        courseCardImagePull();
        courseCardHover();
        courseCardHeight();
    });