var select2DefaultOptions = {
    minimumResultsForSearch: Infinity,
    language: {
        noResults: function () {
            return "";
        }
    },
    width: '100%'
};

function select2Init() {
    $(document).find('.js-select2').each(function() {
        var $this = $(this);

        if ($this.is('[data-placeholder]')) {
            $this.select2($.extend(
                select2DefaultOptions,
                {placeholder: $this.data('placeholder')}
            ));
        } else {
            $this.select2(select2DefaultOptions);
        }
    });
}

function setSelect2ContainerProperWidth() {
    $(document).find('.select2-container').each(function() { // Rounding custom select 'width: 100% to integer
        var $this = $(this);
        var $closestForm = $this.closest('form');
        var $closestFormCol = $this.closest('.default-form__col');

        $this.css('width', '');

        if ($closestFormCol.length) {
            $this.css('width', Math.round($closestFormCol.width()));
        } else if ($closestForm.length) {
            $this.css('width', Math.round($closestForm.width()));
        } else {
            $this.css('width', Math.round($this.width()));
        }
    });
}

$(window)
    .load(function () {
        select2Init();
        setSelect2ContainerProperWidth();
    })
    .smartresize(function() {
        $('.js-select').select2('close'); // Close select2 dropdown to prevent wrong repositioning
        setSelect2ContainerProperWidth();
    });