$ ->
  $('.js-max_length').keyup ->


    currentLength = $(this).val().length
    maxLength = $(this).data('maxlength')
    $textAreaCounter = $('.js-textarea_counter')
    lengthLeft = maxLength - currentLength

    $textAreaCounter.html(lengthLeft)
    counterClass = if lengthLeft < 0 then '__exceeded' else '__normal'
    $textAreaCounter.removeClass('__exceeded').removeClass('__normal')
    $textAreaCounter.addClass(counterClass)

  return