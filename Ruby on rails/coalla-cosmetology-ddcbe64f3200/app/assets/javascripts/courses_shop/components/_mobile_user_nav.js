var $mobileUserNav = $('#mobile-user-nav');
var $mobileUserNavOpen = $('#mobile-user-nav-open');
var $mobileUserNavClose = $('#mobile-user-nav-close');

function mobileUserNavOpen() {
    $('body').css({
        'padding-right': scrollSize().width + 'px',
        'overflow': 'hidden'
    });

    $('#site-header').css('transition', 'none');
    $('#site-header, #site-footer').css('right', scrollSize().width + 'px');

    $mobileUserNav.fadeIn(BASE_TRANSITION_DURATION);
}

function mobileUserNavClose() {
    $mobileUserNav.fadeOut(BASE_TRANSITION_DURATION, function() {
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
$mobileUserNavOpen.on('click', function() {
    mobileUserNavOpen();

    return false;
});

// Close
$mobileUserNavClose.on('click', function() {
    mobileUserNavClose();

    return false;
});