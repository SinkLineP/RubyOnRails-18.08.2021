//= require vendor/select2.full.min

function formatState (option) {
    if (!option.id) { return option.text; }
    var $option = $(
        '<span class="select-grid"><img src="' + $(option.element).data('preview') + '" /><span>' + option.text + '</span></span>'
    );
    return $option;
};


$('.js-video-select2').select2({
    templateResult: formatState,
    templateSelection: formatState
});
