$ ->
  initDatepicker()
  initFileUpload()

  $(document).on 'click', '.js-remove-scan', ->
    $(@).closest('.material-a').find('[data-destroy]').val('1')
    $(@).closest('.material-a').closest('.grid_i').hide()

  $('.js-scan').fileupload
    url: Routes.admin_private_file_path()
    dataType: 'json'
    type: 'POST'
    formData: {}
    paramName: 'file'
    replaceFileInput: false
    done: (e, data)->
      if data.result.error
        alert(data.result.error)
        return
      id = (new Date).getTime()
      $scan = $($('#scan_template').html().replace(new RegExp('__id__', 'g'), id))
      $(@).closest('.grid_i').before($scan)
      $scan.find('[data-cache]').val(data.result.cache)
      $scan.find('[data-destroy]').val('0')
      $scan.find('[data-extension]').text(data.result.extension)
      $scan.find('[data-filename]').text(data.result.filename)
      $(@).val('')

  $('.js-group select, .js-work select').change ->
    $that = $(this)
    $.post Routes.admin_student_work_results_path(), $('#work_result_form').serialize(), (responce)->
      if responce.error
        alert(responce.error)
        $that.val('')
        $that.change()
        return false
      $('.js-student-work-results').replaceWith($(responce.html))
      $('.js-student-work-results').customForm()

  $(document).on 'change', '.js-absent', ->
    $block = $(@).closest('.grid').find('.js-exercise-results')

    if $(@).is(':checked')
      $block.hide()
    else
      $block.show()

  $('.js-group select').change ->
    groupId = $(@).val()
    $worksSelect = $('.js-work select')
    $worksSelect.html('')
    $worksSelect.append($('<option>', {text: 'не выбрано', value: ''}))

    if groupId == undefined || groupId.length == 0
      return

    $.get Routes.admin_course_works_path(group_id: groupId), (works)->
      _.each works, (work)->
        $worksSelect.append($('<option>', {text: work.title, value: work.id}))

      $worksSelect.find('option:first').attr('selected', 'selected')
      $worksSelect.selectOrDie('update')