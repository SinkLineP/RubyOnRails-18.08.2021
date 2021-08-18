$('#scroll-to-models-schedule').on('click', function() {
    $('html, body').animate({scrollTop: $('#models-schedule').position().top - SITE_HEADER_SMALL_HEIGHT - 40 + 1}, SLIDE_TRANSITION_DURATION);

    return false;
});