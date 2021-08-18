//= require vendor/lazysizes

$(function() {
    document.addEventListener('lazybeforeunveil', function(e){
        var bg = e.target.getAttribute('data-bg');
        if(bg){
            e.target.style.backgroundImage = 'url(' + bg + ')';
        }
    });

    $(document).on('lazybeforeunveil', function(e){
        var ajax = $(e.target).data('ajax');
        if(ajax){
            $(e.target).load(ajax);
        }
    });
});
