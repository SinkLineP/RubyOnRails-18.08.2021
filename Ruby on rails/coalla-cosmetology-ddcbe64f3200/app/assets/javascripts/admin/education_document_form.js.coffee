#=require ./base_form
EducationDocumentForm = Views.BaseForm.extend
  el: '#education_document_form'

  events:
    'ajax:success': 'afterSave'
    'click .js-remove-picture': 'removePicture'

  initialize: ->
    @.initSelectOrDie(@.$el)
    $('.js-form').customForm();

    $('.js-picture').fileupload
      url: Routes.admin_education_document_picture_path()
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
        $picture = $($('#picture_template').html().replace(new RegExp('__id__', 'g'), id))
        $(@).closest('.grid_i').before($picture)
        $picture.find('[data-cache]').val(data.result.cache)
        $picture.find('[data-destroy]').val('0')
        $picture.find('[data-extension]').text(data.result.extension)
        $picture.find('[data-filename]').text(data.result.filename)
        $(@).val('')

  removePicture: (e)->
    $link = $(e.currentTarget)
    $link.closest('.material-a').find('[data-destroy]').val('1')
    $link.closest('.material-a').closest('.grid_i').hide()

new EducationDocumentForm()