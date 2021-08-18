$(document).on('ajax:success', '[data-password-form]', function (e, responce) {
    var $form = $(this);

    if (responce.errors) {
        _.each(responce.errors, function (errors, field) {
            var $item = $form.find('[name*="[' + field + '"]').closest('.form_el');
            $item.attr('data-valid', 'false');
            $('<div class="form_error">' + errors + '</div>').insertAfter($item);
        });

        return false;
    }

    if (responce.success) {
        $.arcticmodal('close');
        $(responce.success).arcticmodal();
        return false;
    }

    return false;
});

$(document).on('ajax:error', '[data-password-form]', function (e, responce) {
    console.log(responce);
    alert('Извините. Произошла ошибка при обращении к серверу');
    return false;
});

$(document).on('ajax:before', '[data-password-form]', function () {
    $(this).find('[data-valid]').removeAttr('data-valid');
    $(this).find('.form_error').remove();
    return true;
});
