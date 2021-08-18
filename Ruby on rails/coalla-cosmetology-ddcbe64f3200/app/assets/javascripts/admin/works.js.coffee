$ ->
  $('.js-work-type-select select').change ->

    if $(@).val() == 'Exam' || $(@).val() == 'PracticeWork'
      $('.js-hairdresser-form-sheet').hide()
      $('.js-form-sheet').show()
      $('.js-work-criterion').show()
      $('.js-work-statement-criterion').hide()
    else if $(@).val() == 'HairdresserWork'
      $('.js-work-criterion').hide()
      $('.js-form-sheet').hide()
      $('.js-hairdresser-form-sheet').show()
      $('.js-work-statement-criterion').show()
    else
      $('.js-work-criterion').hide()
      $('.js-form-sheet').hide()
      $('.js-work-statement-criterion').hide()


  $('.js-form-sheet select, .js-hairdresser-form-sheet select, .js-work-type-select select').change ->
    $.post Routes.admin_exercises_path(), $('#work_form').serialize(), (responce)->
      $('.js-exercises').replaceWith($(responce.html))