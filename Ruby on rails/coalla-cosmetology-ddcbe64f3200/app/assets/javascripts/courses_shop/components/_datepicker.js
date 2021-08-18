var $datepicker = $('.js-datepicker');

function datepickerHide() {
    $datepicker.datepicker('hide');
    $datepicker.blur();
}

$datepicker.datepicker({
    showOtherMonths: false,
    minDate: 0,
    prevText: '<svg class="icon" role="img" data-size="18"><use xlink:href="/assets/courses_shop/icons.svg#arrow-left"/></svg>',
    nextText: '<svg class="icon" role="img" data-size="18"><use xlink:href="/assets/courses_shop/icons.svg#arrow-right"/></svg>',
    showOptions: {
        direction: 'up'
    },
    beforeShow: function(input, inst) {
        var inputWidth = $(input).outerWidth();
        var $dpDiv = $(inst.dpDiv);
        var dpDivWidth;
        var dpDivLeft;

        setTimeout(function() { // Waiting .datepicker() to append data
            dpDivWidth = $dpDiv.outerWidth();
            dpDivLeft = parseInt($dpDiv.css('left'));

            $dpDiv
                .css('left', dpDivLeft - ((dpDivWidth - inputWidth) / 2))
                .css({
                    'opacity': '1',
                    'visibility': 'visible'
                });

            $('.ui-datepicker-prev, .ui-datepicker-next').attr('title', '');
        }, 10);
    },
    onClose: function(dateText, inst) {
        $(inst.dpDiv).css({
            'opacity': '',
            'visibility': ''
        });
    }
});

$(window)
    .smartresize(function() {
        datepickerHide();
    })
    .scroll(function() {
        datepickerHide();
    });