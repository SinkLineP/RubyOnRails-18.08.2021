//= require jquery
//= require jquery_ujs
//= require courses_shop/new_base/vendor/jquery.inputmask.bundle
//= require courses_shop/new_base/vendor/jquery.magnific-popup
//= require courses_shop/new_base/vendor/slick
//= require courses_shop/utilities/_scrollsize
//= require courses_shop/_variables
//= require courses_shop/vendor/underscore
//= require courses_shop/new_base/_popups
//= require courses_shop/new_base/_trackable
//= require courses_shop/new_base/components/_partners
//= require lazyload

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
            if (href === '#promo') {
                $('#promo-form-input').focus();
            }
        });

        return false;
    });

    // Popup
    $('.js-popup').magnificPopup({
        type: 'inline',
        preloader: false,
        focus: '#popup-form-input',

        // When elemened is focused, some mobile browsers in some cases zoom in
        // It looks not nice, so we disable it:
        callbacks: {
            beforeOpen: function() {
                if($(window).width() < 1025) {
                    this.st.focus = false;
                } else {
                    this.st.focus = '#popup-form-input';
                }
            }
        }
    });

    $(document).on('change', '.js-agree-checkbox', function () {
        var $btn = $(this).closest('form').find('button');
        if(this.checked) {
            $btn.removeAttr('disabled')

        }else {
            $btn.attr('disabled', 'disabled');
        }
    });

});
