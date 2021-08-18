//= require jquery
//= require jquery_ujs
//= require vendor/intl-tel-input/js/intlTelInput-jquery
//= require vendor/intl-tel-input/js/utils
//= require vendor/jquery.maskedinput
//= require courses_shop/vendor/underscore
//= require sikorsky_school/_trackable

$(function() {

    // Tel mask
    $('.js-mask-tel').inputmask({
        mask: '+7 (999) 999-99-99',
        placeholder: '+7 (___) ___-__-__'
    });

    // Scroll to
    $('.js-scroll-to').on('click', function() {
        var href = $(this).attr('href');

        $('html, body').animate({scrollTop: $(href).position().top}, 200, function() {
            if (href === '#page-banner') {
                $('#discount-form')
                    .find('input[autofocus]')
                    .focus();
            }
        });

        return false;
    });

});
