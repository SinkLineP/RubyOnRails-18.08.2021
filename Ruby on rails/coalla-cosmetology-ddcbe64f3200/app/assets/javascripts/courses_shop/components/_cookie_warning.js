setTimeout(function () {
    $('.js-cookie-warning').addClass('is-active');
}, 2000);

$(document).on('click', '.js-cookie-warning-close', function () {
    var $warningPopup = $(this).closest('.js-cookie-warning');
    $.cookie('cookie_warning_showed', true, {expires: 100 * 365});
    $.post(Routes.confirm_courses_shop_privacy_policy_path(), function (response) {
        if (response.success) {
            $warningPopup.addClass('is-close');
        }
    });

    return false
});