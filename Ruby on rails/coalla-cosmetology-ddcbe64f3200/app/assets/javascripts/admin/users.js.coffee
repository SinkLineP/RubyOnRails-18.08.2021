$ ->
  $('#add-file-btn').fileupload
    url: Routes.import_admin_students_path()
    dataType: 'json'
    singleFileUploads: true
    done: (e, data)->
      $('#import').html(data.result.errors)

  $('.js-edit-multiple').click ->
    userIds = []
    $('[data-id]:checked').each (idx, el) ->
      userIds.push($(el).data('id'))

    if !_.isEmpty(userIds)
      Modal.openModal(Routes.new_admin_course_students_path('user_ids[]': userIds, page: $(@).data('page')))
      return false
    else
      alert('Необходимо выбрать студентов для редактирования.')
      return false