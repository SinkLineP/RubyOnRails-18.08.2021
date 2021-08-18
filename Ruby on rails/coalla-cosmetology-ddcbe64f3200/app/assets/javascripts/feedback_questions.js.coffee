$ ->
  $('.js-feedback-question-file').change ->
    $fileInput = $(this)

    formData = new FormData
    formData.append 'file', @files[0]

    $.ajax
      url: Routes.feedback_question_files_path()
      data: formData
      method: 'POST'
      processData: false
      contentType: false
      success: (response) ->
        if response.error
          alert(response.error)
        else
          $fileInput.closest('.form_file').find('input:hidden').val(response.fileCache)
        return false
      error: ->
        alert 'Произошла ошибка при обращении к серверу.'
        return false
    return false

  $(document).on 'change', '.js-feedback-type-select', ->
    $selected = $(this).find(':selected')

    $('.js-feedback-form').hide().find('input,textarea').attr('disabled', 'disabled');
    $(".js-feedback-form##{$selected.data('feedback-form')}").show().find('input,textarea').removeAttr('disabled');

  return