$('.js-tooltip').on('click', function(e) {
    var $this = $(this);
    var $tooltipPopup = $this.find('.tooltip__popup');

    // TODO(ar): Слава, проверь этот фикс для ссылок
    var $target = $(e.target);
    if($target.is('a') && !$target.hasClass('js-tooltip')) {
        return true;
    }

    $('.js-tooltip').not($this).attr('data-visibility', 'hidden'); // Close all previously opened tooltips

    if (!$tooltipPopup.is(e.target) && $tooltipPopup.has(e.target).length === 0) {
        $this.toggleAttr('data-visibility', 'visible', 'hidden');
    }

    return false;
});

$(document).on('click', function(e) {
    var $tooltip = $('.js-tooltip');
    var $tooltipPopup = $tooltip.find('.tooltip__popup');

    if (!$tooltipPopup.is(e.target) && $tooltipPopup.has(e.target).length === 0) {
        $tooltip.attr('data-visibility', 'hidden');
    }
});