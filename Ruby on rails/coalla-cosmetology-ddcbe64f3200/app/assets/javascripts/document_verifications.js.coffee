$ ->
  $('.js-number').keypress ->
    if $(@).val().length > 0
      $('#submit_verification').removeAttr('disabled').closest('.form_el').removeAttr('disabled')
    else
      $('#submit_verification').attr('disabled', 'disabled').closest('.form_el').attr('disabled', 'disabled')