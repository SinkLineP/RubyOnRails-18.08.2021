$(document).on('change', '#group_subscription_group_id, #group_subscription_education_form_id', function reloadGoupContent() {
    var $groupSelect = $('#group_subscription_group_id'),
        $educationFormSelect = $('#group_subscription_education_form_id'),
        $form = $groupSelect.closest('form'),
        groupId = $groupSelect.val(),
        educationFormId = $educationFormSelect.val(),
        subscriptionId = $form.attr('data-subscription-id');

    $.get(Routes.courses_shop_group_path(groupId, {
        subscription_id: subscriptionId,
        education_form_id: educationFormId
    }), function (response) {
        $form.find('button[type="submit"]').attr('disabled', response.lock);
        if (response.info) {
            $('.js-group-content').empty().append(response.info);
            select2Init();
            setSelect2ContainerProperWidth();
        }
    });
});

$(document).on('click', '.js-already-signed', function () {
    popups.mfpShowInfo('Внимание!', 'Вы уже учились у нас на курсе "' + $(this).data('course-name') + '" или данный курс уже добавлен в корзину. Запишитесь на другой курс. Если вы действительно хотите еще раз пройти обучение по тому же курсу, то напишите на info@cosmeticru.com.', '#popup-info')
});

