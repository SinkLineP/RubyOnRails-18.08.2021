$(document).on('ajax:success', '[data-trackable]', function (e, data) {
    var $this = $(this);
    $('.preloader').css('display', 'none');


    if (data.resetForm) {
        $this.find('input,textarea').val('').change();
        $this.find('[data-validation]').attr('data-validation', '').attr('data-validation-text', '');
        formFillStarted = false;
    }

    if (data.dataLayer) {
        window.dataLayer = window.dataLayer || [];
        console.log("dataLayer: ");
        console.log(data.dataLayer);
        dataLayer.push(data.dataLayer);
        console.log("dataLayer pushed");
    }

    if (data.fbEvent) {
        window.dataLayer = window.dataLayer || [];
        dataLayer.push({event: data.fbEvent});
        console.log("fb_event: ", data.fbEvent);
    }

    if (data.mindbox) {
        var callback;
        if (data.location) {
            callback = function () {
                window.location = data.location;
            };
        }
        mindboxWrapper.operation(data.mindbox, callback);
    }

    var otherPopup = data.otherPopup;
    if (data.location) {
        window.location = data.location;
    }
    else if (data.popup) {
        popups.mfpShowInfo(data.popup.title, data.popup.text, data.popup.name, data.popup.link);
    }
    else if (otherPopup) {
        popups.mfpOpenPopup(otherPopup.name, otherPopup.link);
        var loginPopup = '#popup-login';
        if(otherPopup.name == loginPopup && otherPopup.email) {
            $(loginPopup).find("input[name='user[email]']").val(otherPopup.email);
            $('.js-popup-login-subtext').html("Вы уже регистрировались у нас.<br>Введите пароль или восстановите его по ссылке.");
        }
    }
    else if (data.reload) {
        window.location.reload()
    }
    else if (data.errors) {
        $this.find('[data-validation]').attr('data-validation', '').attr('data-validation-text', '');
        _.each(data.errors, function (errors, attribute) {
            var attributeName = _.last(attribute.split('.'));
            $this.find("[name$='[" + attributeName + "]']").parent().attr('data-validation', 'invalid').attr('data-validation-text', errors.join(', '));
            $this.find("[name$='" + attributeName + "']").parent().attr('data-validation', 'invalid').attr('data-validation-text', errors.join(', '));
            if (attributeName == 'email' && errors.indexOf('уже существует') != -1) {
                $('.js-restore-password').closest('.default-form__row').css('display', 'block');
            }
        });
    }
});

$(document).on('ajax:error', '[data-trackable]', function (e, data) {
    popups.mfpShowInfo('Произошла ошибка', 'Приносим свои извинения. Мы постараемся устранить ошибку в ближайшее время', '#popup-info');
});
