$('#schedule-toggle').on('click', function() {
    var $this = $(this);

    $this.find('.icon').toggleClass('is-rotated');
    $this.find('> span').toggleText('Скрыть', 'На консультацию');

    $('#schedule-content').stop(0).slideToggle(SLIDE_TOGGLE_DURATION);

    setSelect2ContainerProperWidth();

    return false;
});