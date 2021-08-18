$('.js-enroll-btn').on("click", function () {
    var courseId = $(this).attr('data-course-id');
    Cookie.setCookie('course_id', courseId);
    $('#promo_subscription_course_id').val(courseId);
});

$('.js-promo-subscription-btn').on("click", function () {
    var courseId = $(this).attr('data-course-id');
    var isBlog = $(this).attr('data-blog');
    $('#promo_subscription_course_id').val(courseId);
    $('#promo_subscription_blog_id').val(isBlog);
});

$('.js-restore-password').on("click", function () {
    var $form = $(this).closest('.default-form');
    $form.find('#social').remove();
    $form.find('#user_last_name').remove();
    $form.find('#user_first_name').remove();
    history.pushState('', document.title, window.location.pathname);
    $form.attr('action', Routes.courses_shop_user_password_path() ).submit();
   return false
});

$(function () {
    var courseId = Cookie.getCookie('course_id');
    if (!courseId) {
        return;
    }
    $('.js-sign-on-course-link[data-course-id="' + courseId + '"]').click();
    Cookie.deleteCookie('course_id');
});

$('.js-select-courses').on('change', function(e) {
    location.href = $(this).val();
});
