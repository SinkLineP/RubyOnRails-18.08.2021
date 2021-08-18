$ ->
  $('input:radio').click ->
    $('#submit_test').removeAttr('disabled').closest('.form_el').removeAttr('disabled')

  $('#submit_test').click ->
    $(this).attr('disabled', 'disabled').closest('.form_el').attr('disabled', 'disabled')

    $form = $(this).closest('form')
    $questionBlock = $(this).closest('[data-questions-count]')
    $question = $form.find('[data-question]:visible')
    $nextQuestion = $question.nextAll('[data-answered="false"]:first')

    if $nextQuestion.length == 0
      $nextQuestion = $question.prevAll('[data-answered="false"]:last')

    if $nextQuestion.length > 0
      $question.attr('data-answered', 'true')
      $question.hide()
      $nextQuestion.show()
      questions_count = +$questionBlock.attr('data-questions-count')
      answered_questions_count = +$questionBlock.attr('data-answered-questions-count')
      answered_questions_count += 1

      if questions_count - answered_questions_count == 1
        $('#next_question').attr('disabled', 'disabled').closest('.form_el').attr('disabled', 'disabled')

      if questions_count - answered_questions_count == 0
        $(this).closest('.form_el').remove()
        $form.submit()

      $questionBlock.attr('data-answered-questions-count', answered_questions_count)
      $('.js-questions-counter').text("Вы ответили на #{answered_questions_count} из #{questions_count} вопросов, осталось - #{questions_count - answered_questions_count}")
    else
      $(this).closest('.form_el').remove()
      $form.submit()

  $('#next_question').click ->
    $form = $(this).closest('form')
    $questionBlock = $(this).closest('[data-questions-count]')
    $question = $form.find('[data-question]:visible')
    $nextQuestion = $question.nextAll('[data-answered="false"]:first')

    if $nextQuestion.length == 0
      $nextQuestion = $question.prevAll('[data-answered="false"]:last')

    if $nextQuestion.length == 0
      return

    $('#submit_test').attr('disabled', 'disabled').closest('.form_el').attr('disabled', 'disabled')

    $question.hide()
    $nextQuestion.show()
