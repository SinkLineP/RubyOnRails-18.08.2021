#= require vendor/select2.full.min
#=require ./images
#=require ./base_form
$ ->
  EditInstructorForm = Views.BaseForm.extend
    el: '#edit_user_form'

    events:
      'ajax:success': 'afterSave'
      'click .js-add-group-btn': 'addGroup'
      'change .js-course-select': 'loadGroups'
      'change .js-group-select': 'setStudentsCount'
      'click .js-remove-group': 'removeGroup'
      'click .js-remove-block': 'removeBlock'
      'cocoon:after-insert .admin_body': 'addCocoonItem'

    addCocoonItem: (e, inserted_item) ->
      $(inserted_item).find('.js-select2').select2()
      $(inserted_item).customForm()

    initialize: ->
      @.$el.find('.js-select2').select2()
      initImageUpload()
      @.initBlocksAutocomplete()

    addGroup: (e, data)->
      $templateSelect = $($('#select-template').html())
      $(e.currentTarget).before($templateSelect)
      @.initSelectOrDie($templateSelect)
      false

    setStudentsCount: (e, data)->
      $select = $(e.currentTarget)
      studentsCount = $select.find('option:selected').data('students-count')
      $select.closest('.grid_i').next('.grid_i').find('span').text(studentsCount)

    changePasswords: (e, data)->
      that = @
      $form = @.$el
      newPassword = $form.find('#user_password').val()
      id = $form.find('#user_id').val()
      $.ajax
        type: 'PUT',
        data: {password: newPassword}
        url: Routes.change_password_admin_instructor_path(id)
        success: (response, status, e)->
          that.afterSave(e, response)
      false

    removeGroup: (e)->
      $link = $(e.currentTarget)
      $group = $link.closest('.js-group')
      $group.remove()

      return false

  new EditInstructorForm()

$block_textarea = $('#home_teacher_description')
lht = parseInt($block_textarea.css('lineHeight'), 10)
paddings = parseInt($block_textarea.css('padding-top'), 10) + parseInt($block_textarea.css('padding-bottom'), 10)
$block_textarea.change ->
  lines = ($block_textarea.get(0).scrollHeight - paddings) / lht
  $('#home_desctiprion_length').val parseInt(lines)
  return