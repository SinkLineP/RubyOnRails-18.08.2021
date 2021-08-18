$('.js-password-toggle').on('click', function() {
    var $this = $(this);

    $this.toggleClass('is-active');

    $this
        .closest('.js-password')
        .find('.js-password-input')
        .toggleAttr('type', 'text', 'password')
        .focus();

    return false;
});