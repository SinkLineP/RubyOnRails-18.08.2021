$(function () {
    initDatepicker();

    $(document).on('change', '.js-used-date', function () {
        UsedTime.updatePossibleTimes($(this), $('.js-used-time'), true);
    });
});
