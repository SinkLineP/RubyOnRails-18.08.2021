$(function () {
    $('[data-profile-course-order]').click(function () {
        $.ajax({
            url: $(this).attr('data-url'),
            method: 'GET',
            success: function (data) {
                popups.mfpShowContent(data.popup, '#popup-basket-payment-method-select');
                if (data.fbEvent) {
                    window.dataLayer = window.dataLayer || [];
                    dataLayer.push({event: data.fbEvent});
                    console.log("fb_event: ", data.fbEvent);
                }
            }
        });

        return false;
    });
});
