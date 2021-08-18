#= require vendor/select2.full.min
$ ->
  $('#q_course_id_eq').change ->
    $('#q_groups_id_eq').val('')
    $(@).closest('form')[0].submit()

  $('#q_groups_id_eq').change ->
    $('#q_course_id_eq').val('')
    $(@).closest('form')[0].submit()

  $('.js-submit-form').change ->
    $(@).closest('form')[0].submit()

  $('.js-course-select2').select2()