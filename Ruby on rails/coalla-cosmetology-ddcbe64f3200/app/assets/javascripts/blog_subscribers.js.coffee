$ ->
  $('[data-blog-subscribe-from]').on 'ajax:success', (e, responce) ->
    $form = $(this)
    $email = $(this).find('#email')

    if (responce.error)
      $email.closest('.form_el').attr('data-valid', false).attr('title', responce.error)
      $email.focus();
      return false

    $form.find('label').text(responce.message);
    $form.find('.grid_i:not(:first)').remove();
  return false

  $('[data-blog-subscribe-from]').on 'ajax:error', () ->
    alert('Извините. Произошла ошибка при обращении к серверу.')
  return false