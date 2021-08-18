function scrollSize() {
    var css = {
        'width':   '200px',
        'height':  '200px',
        'margin':  '0',
        'padding': '0',
        'border':  'none'
    };

    var inner = $('<div>').css($.extend({}, css));
    var outer = $('<div>')
        .css($.extend({
            'position': 'absolute',
            'top':      '-1000px',
            'left':     '-1000px',
            'overflow': 'scroll'
        }, css))
        .append(inner)
        .appendTo('body')
        .scrollTop(1000)
        .scrollLeft(1000);

    var scrollSize = {
        'width': (outer.offset().left - inner.offset().left) || 0,
        'height': (outer.offset().top - inner.offset().top) || 0
    };

    outer.remove();

    return scrollSize;
}