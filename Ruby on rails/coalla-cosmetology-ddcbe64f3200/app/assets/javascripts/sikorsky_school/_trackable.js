$(document).on('ajax:success', '[data-trackable]', function (e, data) {
    var $this = $(this);

    if (data.popup) {
        var $alert = $('<div class="discount__alert"></div>');
        $this.replaceWith($alert);
        $alert.append('<p>' + data.popup.title + '</p>')
            .append('<p>' + data.popup.text + '</p>');
    }
    else if (data.errors) {
        $this.find('.is-invalid').removeClass('is-invalid').attr('title', '');
        _.each(data.errors, function (errors, attribute) {
            var attributeName = _.last(attribute.split('.'));
            $this.find("[name$='[" + attributeName + "]']").addClass('is-invalid').attr('title', errors.join(', '));
            $this.find("[name$='" + attributeName + "']").addClass('is-invalid').attr('title', errors.join(', '));
        });
    }
});

$(document).on('ajax:error', '[data-trackable]', function (e, data) {
    alert('Приносим свои извинения, произошла ошибка. Мы постараемся устранить ошибку в ближайшее время');
});