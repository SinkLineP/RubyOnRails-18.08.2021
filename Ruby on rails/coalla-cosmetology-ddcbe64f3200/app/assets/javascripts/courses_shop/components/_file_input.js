$('.js-file-input').on('change', function() {
    var $this = $(this);
    var value = $this.val().split(/[\\\/]/).pop();
    var $file = $this.next('span');

    if (value) {
        $this.attr('data-file', value);
        $file.text(value);
    } else {
        $this.removeAttr('data-file');
        $file.text('Выберите файл...')
    }

    return false;
});