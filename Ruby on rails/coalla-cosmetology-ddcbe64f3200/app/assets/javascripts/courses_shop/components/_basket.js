$('.js-basket-item-toggle').on('change', function() {
    $(this)
        .closest('.js-basket-item')
        .find('.js-course-item')
        .toggleAttr('data-selected', 'selected-true', 'selected-false');

    return false;
});

function enableBasketItemCheckboxes() {
    $('.js-basket-item').each(function() {
        $(this)
            .find('.js-basket-item-toggle')
            .removeAttr('disabled');
    });
}

// Fix for Firefox (Firefox remembers previous form elements states after page refresh not reseting it to their initial state)
function checkBasketItemCheckboxesInitialProp() {
    $('.js-basket-item').each(function() {
        var $this = $(this);
        var $checkbox = $this.find('.js-basket-item-toggle');
        var $courseItem = $this.find('.js-course-item');

        if (!$checkbox.prop('checked')) {
            $courseItem.attr('data-selected', 'selected-false');
        }
    });
}

enableBasketItemCheckboxes();
checkBasketItemCheckboxesInitialProp();