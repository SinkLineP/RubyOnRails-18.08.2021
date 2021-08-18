//= require vendor/select2.full.min

$(function(){
    var template = $('#block-template').html();

    $('.js-block-add').click(function(){
        var $this = $(this);
        var $list = $this.closest('.js-block-list');
        $list.append(template);
        $('.js-block-select2').select2();
        refreshSubmit();
        return false;
    });

    $(document).on('touchend click', '.js-block-remove', function () {
        $(this).closest('.js-block-nested-fields').remove();
        refreshSubmit();
    });
    
    function refreshSubmit() {
        var $btn = $('.js-block-submit');

        if($('.js-block-nested-fields').length > 0 ){
            $btn.show();
        } else{
            $btn.hide();
        }
    }

    $(document).on('ajax:success', '#block-form', function(e, responce) {
        if (responce.error) {
            alert(responce.error);
            return false;
        }
        alert('Процесс запущен, по окончание на почту придёт письмо!');
        window.location = Routes.admin_blocks_path();

    });

    $(document).on('ajax:error', '#block-form', function() {
        alert('Извините. Произошла ошибка при обращении к серверу.')
    });

});
