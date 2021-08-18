var UsedTime = {};
UsedTime.updatePossibleTimes = function ($this, $timesSelect, skipAllDay) {
    $.get(Routes.list_used_times_path(), {date: $this.val(), skip_all_day: skipAllDay}, function (result) {
        if (!result.selectOptions) {
            return;
        }

        $timesSelect.html('');

        if (!result.selectOptions) {
            $timesSelect.append($('<option>', {text: 'Выберите дату', value: null}))
            $timesSelect.selectOrDie('update');
            return;
        }

        if (result.selectOptions.length > 0) {
            _.each(result.selectOptions, function (option) {
                $timesSelect.append($('<option>', {text: option[0], value: option[1]}))
            });
            $timesSelect.find('option:first').attr('selected', 'selected');
            $timesSelect.selectOrDie('update');
        }
        else {
            $timesSelect.append($('<option>', {text: 'Нет свободного времени', value: null}))
            $timesSelect.selectOrDie('update');
            return;
        }
    });

};
