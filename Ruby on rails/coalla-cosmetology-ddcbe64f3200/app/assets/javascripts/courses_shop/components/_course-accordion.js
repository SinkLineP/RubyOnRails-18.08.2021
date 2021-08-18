$(document).on('click', '.js-open-all-groups', function () {

    var $list = $(this).closest('#course-groups').find('.js-course-groups-list-accordion');

    if (!$list.hasClass('is-open')) {

        $list.addClass('is-open');
        $(this).css('display', 'none');
    }

    return false
});