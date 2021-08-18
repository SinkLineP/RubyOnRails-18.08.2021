var formFillStarted = false;
$(function () {
    $('.js-vk-form-fill-started').on('change', function () {
        if (!formFillStarted) {
            formFillStarted = true;
            window.dataLayer = window.dataLayer || [];
            dataLayer.push({event: 'vkFormFillStarted'});
            console.log("vkFormFillStarted");
        }
    });
});