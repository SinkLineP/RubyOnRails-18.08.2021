$(document).on('click', '.js-payment-method-select-item', function() {
    var $this = $(this);
    var $container = $this.closest('.js-payment-method-select');

    $container
        .find('.js-payment-method-select-item')
        .not($this)
        .removeClass('is-selected');

    $this.addClass('is-selected');

    // no return false to check radio and be able to click on links
});