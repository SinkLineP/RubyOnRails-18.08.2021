$(document).on('change', '[data-consultation-date]', function () {
    var $el = $(this),
        $timeSelect = $('[data-consultation-time]');

    $.get(Routes.list_used_times_path(), {date: $el.val(), skip_all_day: true}, function (result) {

        $timeSelect.html('');
        $timeSelect.select2('destroy');

        if (!result.selectOptions) {
            $timeSelect.data('placeholder', 'Выберите дату');
            $timeSelect.select2(select2DefaultOptions);
            $timeSelect.val('');
            return;
        }

        if (result.selectOptions.length > 0) {
            _.each(result.selectOptions, function (option) {
                $timeSelect.append($('<option>', {text: option[0], value: option[1]}))
            });
            $timeSelect.find('option:first').attr('selected', 'selected');
            $timeSelect.select2(select2DefaultOptions);
        } else {
            $timeSelect.data('placeholder', 'Нет свободного времени');
            $timeSelect.select2(select2DefaultOptions);
            $timeSelect.val('');
        }
    });
});
