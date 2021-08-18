var $feedbacksWidgetsPopup = $('.js-feedbacks-widgets-popup');

function feedbacksWidgetsPopupsHide() {
    $feedbacksWidgetsPopup
        .stop(0)
        .slideUp(BASE_TRANSITION_DURATION);
}

$('.js-feedbacks-widgets-popup-open').on('click touchend', function() {
    var $this = $(this);
    var popupId = $this.attr('href');

    feedbacksWidgetsPopupsHide();

    $(popupId)
        .stop(0)
        .slideDown(BASE_TRANSITION_DURATION);

    return false;
});

$('.js-feedbacks-widgets-popup-close').on('click touchend', function() {
    feedbacksWidgetsPopupsHide();

    return false;
});

$(document).on('click', function(e) {
    if (!$feedbacksWidgetsPopup.is(e.target) && $feedbacksWidgetsPopup.has(e.target).length === 0) {
        feedbacksWidgetsPopupsHide();
    }
});