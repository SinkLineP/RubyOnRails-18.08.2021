$(document).on('ajax:success', '[data-trackable]', function (e, data) {
    var $this = $(this);

    if (data.resetForm) {
        $this.find('input,textarea').val('').change();
        $this.find('.is-error').removeClass('is-error');
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

    if (data.location) {
        window.location = data.location;
    }
    else if (data.popup) {
        popups.mfpShowInfo('Спасибо!');
    }
    else if (data.reload) {
        window.location.reload()
    }
    else if (data.errors) {
        $this.find('.is-error').removeClass('is-error');
        _.each(data.errors, function (errors, attribute) {
            $this.find("[name='data[" + attribute + "]']").addClass('is-error');
        });
    }
});

$(document).on('ajax:error', '[data-trackable]', function (e, data) {
    alert('Произошла ошибка, приносим свои извинения. Мы постараемся устранить ошибку в ближайшее время');
});