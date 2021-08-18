var $siteSearchToggle = $('#site-search-toggle');
var $siteSearchForm = $('#site-search-form');
var $siteSearchInput = $('#site-search-input');

function siteSearchShow() {
    $siteSearchToggle.attr('data-action', 'close');
    $siteSearchForm.fadeIn(BASE_TRANSITION_DURATION);
    $siteSearchInput.focus();
}

function siteSearchHide() {
    $siteSearchToggle.attr('data-action', 'open');
    $siteSearchForm.fadeOut(BASE_TRANSITION_DURATION);
    $siteSearchInput.val('');
}

$siteSearchToggle.on('click', function() {
    if ($siteSearchForm.is(':hidden')) {
        siteSearchShow();
    } else {
        siteSearchHide();
    }

    return false;
});

// Close on blur
$siteSearchInput.on('blur', function() {
    siteSearchHide();

    return false;
});

// Close on Esc key
$(document).on('keyup', function(e) {
    if (e.keyCode == 27) {
        siteSearchHide();
    }

    return false;
});