var $mobileMenu = $('#mobile-menu');
var $mobileMenuOpen = $('#mobile-menu-open');
var $mobileMenuClose = $('#mobile-menu-close');

function mobileMenuOpen() {
    $('body').css({
        'padding-right': scrollSize().width + 'px',
        'overflow': 'hidden'
    });

    $('#site-header').css('transition', 'none');
    $('#site-header, #site-footer').css('right', scrollSize().width + 'px');

    $mobileMenu.fadeIn(BASE_TRANSITION_DURATION);
}

function mobileMenuClose() {
    $mobileMenu.fadeOut(BASE_TRANSITION_DURATION, function() {
        $('body').css({
            'padding-right': '',
            'overflow': ''
        });

        $('#site-header, #site-footer').css('right', '');

        setTimeout(function() {
            $('#site-header').css('transition', '');
        }, BASE_TRANSITION_DURATION);
    });
}

// Open
$mobileMenuOpen.on('click', function() {
    mobileMenuOpen();

    return false;
});

// Close
$mobileMenuClose.on('click', function() {
    mobileMenuClose();

    return false;
});