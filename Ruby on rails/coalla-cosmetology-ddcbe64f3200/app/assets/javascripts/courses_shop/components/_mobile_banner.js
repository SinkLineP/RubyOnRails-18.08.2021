
function openMobileBanner() {

    if ($('.mobile-banner').length) {

        $('html').css('overflow', 'hidden');
        $('body').css('overflow', 'hidden');

        $('.mobile-banner-fade').addClass('is-active');
        $('.mobile-banner').addClass('is-active');

    }
}

function closeMobileBanner() {

    $('html').css('overflow', '');
    $('body').css('overflow', '');

    $('.mobile-banner-fade').remove();
    $('.mobile-banner').remove();

}

$(document).on('click', '#mobile-banner-close', function() {
    closeMobileBanner();
    return false
});

$(document).on('click', '.js-mobile-banner-redirect', function() {
    closeMobileBanner();
});

$(window).on('load', function() {
    setTimeout(openMobileBanner, 30000);
});