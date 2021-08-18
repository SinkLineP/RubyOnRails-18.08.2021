$('.js-personal-cabinet-course-payments-toggle').on('click', function() {
    var $this = $(this);
    var $closestCourse = $this.closest('.js-personal-cabinet-course');

    $closestCourse
        .find('.js-personal-cabinet-course-payments-action')
        .slideToggle(0); // Using .slideToggle() with 0s transition duration because .toggle() turns element into 'display: inline' instead of its initial css property 'display: inline-block'

    $closestCourse
        .find('.js-personal-cabinet-course-payments-list')
        .slideToggle(BASE_TRANSITION_DURATION, function() {
            $this.toggleText('Скрыть график', 'Показать график');
        });

    return false;
});

$('.js-personal-cabinet-course-payments-all').on('change', function() {
    var $this = $(this);
    var $closestPaymentsList = $this.closest('.js-personal-cabinet-course-payments-list');
    var $closestLi = $this.closest('li');

    $closestPaymentsList
        .find('> li:not([data-initial="is-muted"])')
        .toggleClass('is-muted');
    $closestPaymentsList
        .find('> li:not(:last-child) .button')
        .slideToggle(0); // Using .slideToggle() with 0s transition duration because .toggle() turns element into 'display: inline' instead of its initial css property 'display: inline-block'

    $closestLi.toggleClass('is-muted');
    $closestLi
        .find('.button')
        .slideToggle(0); // Using .slideToggle() with 0s transition duration because .toggle() turns element into 'display: inline' instead of its initial css property 'display: inline-block'

    return false;
});