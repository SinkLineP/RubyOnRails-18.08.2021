#=require ./base_form
NoticeForm = Backbone.View.extend
  el: '#new_notice'

  events:
    'ajax:success': 'afterSave'
    'click .js-remove-document-copy': 'removeAttachedFile'

  initialize: ->
    @.initDocumentCopyUploader()
    $('.js-form').customForm()

  initDocumentCopyUploader: ->
    $('.js-attach-file').fileupload
      url: Routes.admin_file_path()
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
        $attachedFile = $($('#notice_attachment_template').html().replace(new RegExp('__id__', 'g'), id))
        $(@).closest('.grid_i').before($attachedFile)
        $attachedFile.find('[data-cache]').val(data.result.cache)
        $attachedFile.find('[data-destroy]').val('0')
        $attachedFile.find('[data-extension]').text(data.result.extension)
        $attachedFile.find('[data-filename]').text(data.result.filename)
        $(@).val('')

  removeAttachedFile: (e)->
    $(e.currentTarget).closest('.material-a').find('[data-destroy]').val('1')
    $(e.currentTarget).closest('.material-a').closest('.grid_i').hide()

new NoticeForm()