// Blockquote
function contentBlockquoteStyles() {
    $(document)
        .find('.js-content blockquote')
        .each(function() {
            $(this)
                .prepend('<svg class="icon" role="img" data-size="34"><use xlink:href="/assets/courses_shop/icons.svg#quote-open"></use></svg>')
                .append('<svg class="icon" role="img" data-size="34"><use xlink:href="/assets/courses_shop/icons.svg#quote-close"></use></svg>');
        });
}

// Figure
function contentFigureWidth() {
    $(document)
        .find('.js-content figure')
        .each(function() {
            $(this)
                .find('> figcaption')
                .css('width', $(this).find('> img').width());
        });
}

// Image
function contentImageReset() {
    $(document)
        .find('.js-content p img')
        .each(function() {
            $(this)
                .css({
                    height: '',
                    width: ''
                })
                .unwrap();
        });
}

// Table
function contentTableResponsive() {
    $(document)
        .find('.js-content table')
        .each(function() {
            $(this).wrap('<div class="content__table"/>');
        });
}

// Video (Youtube, Vimeo)
function contentVideoResponsive() {
    $(document)
        .find('.js-content iframe[src*="vimeo"], .js-content iframe[src*="youtube"]')
        .each(function() {
            $(this).wrap('<div class="content__video"/>');
        });
}



$(window)
    .load(function() {
        contentBlockquoteStyles();
        contentFigureWidth();
        contentImageReset();
        contentTableResponsive();
        contentVideoResponsive();
    })
    .smartresize(function() {
        contentFigureWidth();
    });