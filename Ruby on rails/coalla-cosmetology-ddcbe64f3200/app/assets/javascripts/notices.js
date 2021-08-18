$(document).on('ajax:success', '[data-delete-notice]', function() {
    $(this).closest('.alert').remove();
});

$(document).on('ajax:error', '[data-delete-notice]', function() {
    alert('Извините. Произошла ошибка при обращении к серверу.')
});