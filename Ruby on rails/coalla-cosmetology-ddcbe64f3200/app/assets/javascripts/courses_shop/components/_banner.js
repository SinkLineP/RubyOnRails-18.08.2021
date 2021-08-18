$('.js-banner-close').on('click', function () {
    var $this = $(this);
    $this.closest('.js-banner').hide();
    if ($this.hasClass('js-hide-banner')) {
        $.cookie('banner_showed', true, {expires: 1 / 24});
    }
    closeMobileBanner();
    return false;
});

$(document).ready(function () {
    if (!getParameterByName('banner')) return;
    $('.js-banner-call').hide();
});

$(document).on('ajax:success', '.js-banner-form', function (e, data) {
    var $this = $(this);

    if (data.resetForm) {
        $this.find('input,textarea').val('').change();
        $this.find('[data-validation]').attr('data-validation', '').attr('data-validation-text', '');
    }

    if (data.location) {
        window.location = data.location;
    }
    else if (data.popup) {
        popups.mfpShowInfo(data.popup.title, data.popup.text, data.popup.name, data.popup.link);
    }
    else if (data.otherPopup) {
        closeMobileBanner();
        popups.mfpOpenPopup(data.otherPopup.name, data.otherPopup.link);
    }
    else if (data.reload) {
        window.location.reload()
    }
    else if (data.errors) {
        $this.find('[data-validation]').attr('data-validation', '').attr('data-validation-text', '');
        // TODO (vl): nested attributes?
        _.each(data.errors, function (errors, attribute) {
            var attributeName = _.last(attribute.split('.'));
            $this.find("[name$='[" + attributeName + "]']").parent().attr('data-validation', 'invalid');
            if (attributeName = 'email' && errors.indexOf('уже существует') != -1) {
                $('.js-restore-password').closest('.default-form__row').css('display', 'block')
            }
        });
    }
});

$(document).on('ajax:error', '[data-trackable]', function (e, data) {
    popups.mfpShowInfo('Произошла ошибка', 'Приносим свои извинения. Мы постараемся устранить ошибку в ближайшее время', '#popup-info');
});
