var HolidaysCalendar = function (year, holidays) {
    var dateFormat = 'YYYY-MM-DD',
        $datepickerEl = $('#calendar');

    var year = year,
        holidays = _.map(holidays, function (holiday) {
            return moment(holiday, dateFormat);
        });

    $datepickerEl.datepicker({
        dateFormat: "yy-mm-dd",
        onSelect: function (dateText) {
            var day = moment(dateText, dateFormat);
            if (dayExists(day)) {
                deleteDay(day);
            } else {
                addDay(day);
            }
        },
        beforeShowDay: function (date) {
            var day = moment(date, dateFormat),
                dayClass = '';
            if (dayExists(day)) {
                dayClass = 'ui-holiday';
            }

            return [true, dayClass, null];
        },
        onChangeMonthYear: function (newYear) {
            if (year === newYear) {
                return;
            }

            updateHolidays(newYear);
        }
    });

    function dayExists(day) {
        return !!_.find(holidays, function (holiday) {
            return holiday.isSame(day);
        });
    }

    function deleteDay(day) {
        if (!confirm('Убарать выходной?')) {
            return;
        }
        $.post(Routes.admin_holiday_path(day.format(dateFormat)), {_method: 'delete'}, function () {
            holidays = _.reject(holidays, function (holiday) {
                return holiday.isSame(day);
            });
            $datepickerEl.datepicker('refresh');
        });
    }

    function addDay(day) {
        if (!confirm('Добавить выходной?')) {
            return;
        }
        $.post(Routes.admin_holidays_path(), {day: day.format(dateFormat)}, function () {
            holidays.push(day);
            $datepickerEl.datepicker('refresh');
        });
    }

    function updateHolidays(newYear) {
        $.get(Routes.admin_holidays_path({format: 'json'}), {year: newYear}, function (data) {
            year = newYear;
            holidays = _.map(data.holidays, function (holiday) {
                return moment(holiday, dateFormat);
            });
            $datepickerEl.datepicker('refresh');
        });
    }
};