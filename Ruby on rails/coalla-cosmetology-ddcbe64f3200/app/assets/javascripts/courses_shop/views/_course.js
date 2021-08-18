$(function () {
    var $courseGroups = $('#course-groups');

    $courseGroups.find('.js-course-group').on('click', function () {
        var $el = $(this),
            groupId = $el.find('input').val(),
            courseId = $el.find('input').data('course-id');


        $courseGroups.find('.js-course-group').removeClass('is-selected');
        $el.addClass('is-selected');
        $('.js-sign-on-course-link').attr('href', Routes.new_courses_shop_group_subscription_path({
            course_id: courseId,
            group_id: groupId
        }));
    });
});