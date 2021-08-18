$(document).on('click', '[data-ajax-pagination]', function () {
    var $this = $(this);

    $.get($this.attr('href'), function (responce) {
        var $appendTo = $($this.data('append-to')),
            $paginationComplex = $('#pagination-complex');

        $appendTo.append(responce.items);
        $paginationComplex.replaceWith(responce.paginationComplex);
        if(responce.canonicalUrl && $('[rel="canonical"]').length == 0) {
            $('head').append('<link rel="canonical" href="' + responce.canonicalUrl + '" />')
        }

        contentBlockquoteStyles();
        contentFigureWidth();
        contentTableResponsive();
        contentVideoResponsive();

        window.history.pushState('', '', responce.location);
    });

    return false;
});