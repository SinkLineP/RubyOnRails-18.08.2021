$ ->
  $('.btn-submit').click ->
    $email = $('#feedback_email')
    $message = $('#feedback_message')

    $('[data-valid=false]').removeAttr('data-valid');

    if !validateEmail($email.val())
      $email.closest('.form_el').attr('data-valid', false)

    if !$message.val()
      $message.closest('.form_el').attr('data-valid', false)

    if validateEmail($email.val()) && !!$message.val()
      $(this).attr('disabled', 'disabled')
      $(this).closest('form').submit()
    else
      return false

  validateEmail = (email) ->
    re = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i
    return re.test(email)