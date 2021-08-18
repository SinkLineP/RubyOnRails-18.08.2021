$(function () {
    $(document).on('click touchend','.js-education-group-title', function () {
        var $this = $(this);
        var $group = $this.closest('.js-education-group');
        $this.css('pointer-events', 'none');

        $group.find('.js-education-group-toggle').toggleClass('is-rotated');
        $group.find('.js-education-group-description').stop(0).slideToggle(SLIDE_TOGGLE_DURATION);

        setTimeout(function() {
            $this.css('pointer-events', 'auto');
        }, SLIDE_TOGGLE_DURATION + 100);

        return false;
    });
});