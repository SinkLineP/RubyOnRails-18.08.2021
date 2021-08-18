function pagePromoScrollToggle() {
    if (Modernizr.mq(BREAKPOINT_MOBILE)) {
        // Page next slide
        if (!$pagePromo.find('#page-promo-scroll').length) {
            $pagePromoScroll
                .detach()
                .appendTo('#page-promo');

            $pagePromoScroll
                .css({
                    'position': 'absolute',
                    'opacity': '1',
                    'visibility': 'visible'
                });
        }

        $pagePromoScroll
            .off('click') // Reseting click from desktop
            .on('click', function() {
                var scrollTo = $(this).closest('section').next().position().top - SITE_HEADER_SMALL_HEIGHT + 1;

                $('html, body').animate({scrollTop: scrollTo}, SLIDE_TRANSITION_DURATION);

                return false;
            });
    } else {
        if (windowScrollTop == 0) {
            $pagePromoScroll.css({
                'opacity': '1',
                'visibility': 'visible'
            });
        } else {
            $pagePromoScroll.css({
                'opacity': '',
                'visibility': ''
            });
        }

        // Page next slide
        if ($pagePromo.find('#page-promo-scroll').length) {
            $pagePromoScroll
                .detach()
                .appendTo('#main');

            $pagePromoScroll
                .css({
                    'position': '',
                    'opacity': '',
                    'visibility': ''
                });
        }

        $pagePromoScroll
            .off('click') // Reseting click from mobile
            .on('click', function() {
                var $this = $(this);

                $('html, body').animate({scrollTop: $(window).height() - SITE_HEADER_SMALL_HEIGHT + 1}, SLIDE_TRANSITION_DURATION, function() {
                    $this.css({
                        'opacity': '',
                        'visibility': ''
                    });
                });

                return false;
            });
    }
}

var $pagePromo = $('#page-promo');
var $pagePromoScroll = $('#page-promo-scroll');

var windowScrollTop = $(window).scrollTop();
pagePromoScrollToggle();

$(window)
    .smartresize(function() {
        windowScrollTop = $(window).scrollTop();
        pagePromoScrollToggle();
    })
    .scroll(function() {
        windowScrollTop = $(window).scrollTop();
        pagePromoScrollToggle();
    });