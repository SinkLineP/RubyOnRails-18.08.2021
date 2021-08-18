$(function () {
    $('.js-shop-select').change(function () {
        var url = window.location.href.split('?')[0];
        window.location.href = url + '?shop_id=' + $(this).val();
    })
});