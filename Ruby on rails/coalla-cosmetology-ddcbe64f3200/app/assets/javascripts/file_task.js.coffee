class ResultFileUploader
  constructor: (selector)->
    @$el = $(selector)
    @$fileStepBlock = @$el.closest('.file_step')
    @.initFileUploader()

  initFileUploader: ->
    taskId = @$el.data('taskId');
    firstStep = @$fileStepBlock.hasClass('file_step-1')
    that = @

    @$el.fileupload
      url: Routes.task_files_path(taskId, course_id: $('#course_id').val())
      dataType: 'json'
      type: 'POST'
      formData: {} # to be rails-POST
      dropZone: false
      singleFileUploads: true
      add: (e, data)->
        that.showProgressBar()
        data.submit()
      done: (e, data)->
        that.hideProgressBar()

        if data.result.error
          alert(data.result.error)

        $template = that.prepareTemplate(data.result)

        if firstStep
          that.$fileStepBlock.removeClass('current')
          $('.file_step-3').addClass('current');

        $('.loaded_files').append($template)
        that.$fileStepBlock.find('.form_file_inner').html('ДОБАВИТЬ ФАЙЛЫ')

        that.checkFilesCount()
      error: (e, data)->
        that.hideProgressBar()

  showProgressBar: ->
    @$fileStepBlock.removeClass('current')
    $('.file_step-2').addClass('current')

  hideProgressBar: ->
    $('.file_step-2').removeClass('current')
    @$fileStepBlock.addClass('current')
    @.initFileUploader()

  prepareTemplate: (data)->
    that = @
    template = $('#task-file-template').html()
    time = (new Date).getTime()
    regexp = new RegExp('__id__', 'g')
    $result = $(template.replace(regexp, time))
    $result.prepend(data.fileName)
    $result.find('input:hidden').val(data.fileCache);
    $result.find('.icon_del').click ->
      $(@).closest('.loaded_files-i').remove()
      that.checkFilesCount()
    return $result

  checkFilesCount: ->
    if $('.loaded_files-i').length > 0
      $(':submit').removeAttr('disabled').closest('.form_el').removeAttr('disabled')
    else
      $(':submit').attr('disabled', 'disabled').closest('.form_el').attr('disabled', 'disabled')

@ResultFilesUploader = ResultFileUploader

$ ->
  new ResultFileUploader('.js-file-upload-first-step')
  new ResultFileUploader('.js-file-upload-second-step')
