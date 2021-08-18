var Cart = function () {
    this.updateInfo = function () {
        $.ajax({
            url: Routes.courses_shop_cart_path(),
            data: $('#new_order').serialize(),
            method: 'PUT',
            success: function (response) {
                if (response.mindbox) {
                    mindboxWrapper.operation(response.mindbox);
                }

                if (response.data) {
                    var $newOrderButton = $('[data-new-order]');
                    $('.js-price-block').replaceWith(response.data.priceBlock);
                    if (response.data.lockButton) {
                        $newOrderButton.hide();
                    } else {
                        $newOrderButton.show();
                    }
                }
            }
        });
    };

    this.resetPromoCode = function () {
        $('#promo_code').parent().attr('data-validation', '').attr('data-validation-text', '');
        $('#promo_code').val('');
        $('#order_promo_code_id').val('');
    };
};

var cart = new Cart();

$(function () {
    $(document).on('click', '.js-delete-group-subscription', function () {
        var $el = $(this);

        $.post($el.attr('href'), {_method: 'delete'}, function (data) {
            if (!data.mindbox) {
                if (data.location) {
                    window.location = data.location;
                }
                return;
            }

            var callback;
            if (data.location) {
                callback = function () {
                    window.location = data.location;
                };
            }
            mindboxWrapper.operation(data.mindbox, callback);
        });

        return false;
    });

    $('[data-new-order]').click(function () {
        var force = $(this).data('force');
        $.ajax({
            url: Routes.new_courses_shop_order_path(),
            data: $('#new_order').serialize(),
            method: 'GET',
            success: function (data) {
                var popupEl = '#popup-basket-payment-method-select';
                popups.mfpShowContent(data.popup, popupEl);
                if (data.fbEvent) {
                    window.dataLayer = window.dataLayer || [];
                    dataLayer.push({event: data.fbEvent});
                    console.log("fb_event: ", data.fbEvent);
                }
                if (force) {
                    $(popupEl).css('display', 'none');
                    $('.preloader').css('display', 'block');
                    $('.js-payment-type-select').click();
                }
            }
        });

        return false;
    });

    $('.js-basket-item-toggle').change(function () {
        cart.updateInfo();
        return false;
    });

    $('.js-promo-code').on('click', function () {
        $.post(Routes.check_courses_shop_promo_codes_path(), $('#new_order').serialize(), function (response) {
            if (!response.error && !response.id) {
                return;
            }

            cart.resetPromoCode();

            if (response.error) {
                $('#promo_code').parent().attr('data-validation', 'invalid').attr('data-validation-text', response.error);
                return;
            }

            $('#order_promo_code_id').val(response.id);
            cart.updateInfo();
        });

        return false;
    });
});
