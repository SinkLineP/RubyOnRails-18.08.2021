#= require admin/select_for_videos

B.LectureBodyView = Backbone.View.extend
  tagName: 'div'
  className: 'grid'
  id: 'lecture-body'

  events:
    'keyup #lecture-body-description': 'updateDescription'
    'change .js-read-before-practice': 'updateReadBeforePractice'

  initialize: (lecture)->
    @lecture = lecture
    @render()

    @listenTo(@lecture.downloads, 'add', @downloadAdded)
    @lecture.downloads.each (download) ->
      @downloadAdded(download)
    , @

    that = @

    @$('.js-download-input').fileupload
      url: Routes.admin_download_path()
      dataType: 'json'
      type: 'POST'
      formData: {}
      paramName: 'file'
      replaceFileInput: false
      done: (e, data)->
        if data.result.error
          alert(data.result.error)
          return
        lecture.addDownload(data.result)

    @$('.js-pdf-input').fileupload
      url: Routes.admin_pdf_path()
      dataType: 'json'
      type: 'POST'
      formData: {}
      paramName: 'file'
      replaceFileInput: false
      done: (e, data)->
        if data.result.error
          alert(data.result.error)
          return
        that.addPdf(data.result)

    task = @lecture.task
    opts = if task then {taskType: task.get('type'), taskEditable: @lecture.get('task_editable')} else {}
    selector = new B.TaskTypeSelector(opts)
    @taskTypeSelectorView = new B.TaskTypeSelectorView
      el: @$('.js-task-selector')
      model: selector
    @taskFormView = new B.TasksFormView
      el: @$('.js-tasks-form')
      task: task
      selector: selector
      selectorView: @taskTypeSelectorView

    if @lecture.get('pdf_filename')
      view = new B.PdfView({model: {pdf_extension: @lecture.get('pdf_extension'), pdf_filename: @lecture.get('pdf_filename'), pdf_editable: @lecture.get('pdf_editable')}, view: @})
      @$('.js-pdf-button').hide()
      @$('.js-pdf-button').before(view.render())

    @$('#uploaded_video_id').val(@lecture.get('uploaded_video_id'))

    @$('.js-video-select2').select2
      templateResult: formatState
      templateSelection: formatState

  downloadAdded: (download) ->
    view = new B.DownloadView({model: download})
    @$('.js-download-button').before(view.render())

  addPdf: (data) ->
    @lecture.set('pdf_cache', data.cache)
    @lecture.unset('remove_pdf')
    view = new B.PdfView({model: {pdf_extension: data.extension, pdf_filename: data.filename, pdf_editable: true}, view: @})
    @$('.js-pdf-button').hide()
    @$('.js-pdf-button').before(view.render())

  removePdf: ->
    @lecture.set('pdf_cache', null)
    @lecture.set('remove_pdf', true)
    @$('.js-pdf-button').show()
    @$('.js-pdf-input').val('')

  render: ->
    template = _.template($('#lecture-body-template').html(), @.lecture.toJSON())
    @.$el.html(template)
    @.$el.customForm();

  saveState: ->
    @.updateDescription()
    @.lecture.set('time', @.timeField().val())
    @.lecture.set('term', @.termField().val())
    @.lecture.set('lecture_link', @.lectureLinkField().val())
    @.lecture.set('video_link', @.videoLinkField().val())
    @.lecture.set('uploaded_video_id', @.uploadedVideoSelect().val())
    @.lecture.task = @taskFormView.getActiveTask()

  getState: (lecture)->
    @.descriptionField().val(lecture.get('description'))
    @.timeField().val(lecture.get('time'))
    @.termField().val(lecture.get('term'))
    @.lectureLinkField().val(lecture.get('lecture_link'))
    @.videoLinkField().val(lecture.get('video_link'))
    @.uploadedVideoSelect().val(lecture.get('uploaded_video_id'))
    @.readBeforePractice().val(lecture.get('read_before_practice'))

  remove: ->
    @.$el.remove()

  updateDescription: ->
    @.lecture.set('description', @.descriptionField().val())

  descriptionField: ->
    @.$('#lecture-body-description')

  timeField: ->
    @.$('#lecture-body-time')

  termField: ->
    @.$('#lecture-body-term')

  lectureLinkField: ->
    @.$('#lecture-link')

  videoLinkField: ->
    @.$('#video-link')

  readBeforePractice: ->
    @.$('#read_before_practice')

  uploadedVideoSelect: ->
    @.$('#uploaded_video_id')

  updateReadBeforePractice: (event)->
    @.lecture.set('read_before_practice', event.currentTarget.checked)

  afterDomInsert: ->
    @taskFormView.positionArrow()
