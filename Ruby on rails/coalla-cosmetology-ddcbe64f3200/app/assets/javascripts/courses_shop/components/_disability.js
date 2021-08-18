var $html = $('html');
var $body = $('body');
var $switchSizeItem = $('#js-switch-size > li');
var sizeClass = 'disability--size-medium';
var themeClass = 'disability--theme-base';


function disabilityResize() {
    if (Modernizr.mq(BREAKPOINT_DESKTOP)) {
        var navHeight = $('#disability-navigate').outerHeight();

        $body.css('padding-top', navHeight);
    }
}


$switchSizeItem.on('click', function() {

    $html.removeClass(sizeClass);

    $switchSizeItem.removeClass('is-active');

    sizeClass = $(this).data('size');

    $(this).addClass('is-active');

    $html.addClass(sizeClass);

    disabilityResize();
});

$('#js-switch-theme > li').on('click', function() {
    $body.removeClass(themeClass);

    themeClass = $(this).data('theme');

    $body.addClass(themeClass);
});





$(window)
    .load(function() {
        disabilityResize();
    })
    .smartresize(function() {
        disabilityResize();
    });

