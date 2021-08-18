$(function () {
    $(document).on('click', '.js-course-link', function () {
        window.location = $(this).data('url');
        return false;
    });
});
