#=require ./base_form
EditUserForm = Views.BaseForm.extend
  el: '#edit_user_form'

  events:
    'ajax:success': 'afterUserSaved'
    'click .js-remove-document-copy': 'removeDocumentCopy'
    'click .js-add-student-document': 'addStudentDocument'
    'click .js-remove-student-document': 'removeStudentDocument'
    'click .course_block[data-student-document]': 'clickOnStudentDocument'
    'change .js-student-document-type': 'changeDocumentType'
    'change .js-student-document-title': 'changeDocumentTitle'
    'click .js-edit-comment-thread': 'editComment'

  initialize: ->
    @.studentDocumentTemplate = $('#student_document_template').html()
    @.studentDocumentThumbTemplate = $('#student_document_thumb_template').html()
    @.initDatepicker(@.$el)
    @.initDocumentCopyUploader()
    @.initStudentDocumentUploader(@.$el)
    $('.js-form').customForm()

  afterUserSaved: (e, data)->
    if data.errors
      alert(data.errors)
    else
      window.location = data.redirect_url

  initStudentDocumentUploader: ($block)->
    $block.find('.js-student-document-file').fileupload
      url: Routes.admin_private_file_path()
      dataType: 'json'
      singleFileUploads: false
      type: 'POST'
      formData: {}
      paramName: 'file'
      done: (e, data)->
        if data.result.error
          alert(data.result.error)
          return

        $studentDocument = $(@).closest('.add_document')
        $studentDocument.find('[data-document-cache]').val(data.result.cache)
        $studentDocument.find('.form_file_inner').text(data.result.filename)
        studentDocumentId = $studentDocument.attr('data-student-document')
        $('.course_block[data-student-document="' + studentDocumentId + '"]').find('span:last').text('(' + data.result.filename + ')')

  initDocumentCopyUploader: ->
    $('.js-document-copy').fileupload
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
        $documentCopy = $($('#document_copy_template').html().replace(new RegExp('__id__', 'g'), id))
        $(@).closest('.grid_i').before($documentCopy)
        $documentCopy.find('[data-cache]').val(data.result.cache)
        $documentCopy.find('[data-destroy]').val('0')
        $documentCopy.find('[data-extension]').text(data.result.extension)
        $documentCopy.find('[data-filename]').text(data.result.filename)
        $(@).val('')

  removeDocumentCopy: (e)->
    $(e.currentTarget).closest('.material-a').find('[data-destroy]').val('1')
    $(e.currentTarget).closest('.material-a').closest('.grid_i').hide()

  removeStudentDocument: (e)->
    $thumb = $(e.currentTarget).closest('.course_block')
    $prevThumb = $thumb.prev()
    studentDocumentId = $thumb.attr('data-student-document')
    $thumb.remove()
    $studentDocument = $('.add_ctn[data-student-document="' + studentDocumentId + '"]')
    $studentDocument.find('[data-destroy]').val('1')
    $studentDocument.hide()
    @.selectstudentDocument($prevThumb)

  addStudentDocument: (e)->
    id = (new Date).getTime()

    $studentDocumentThumb = $(@.studentDocumentThumbTemplate)
    $studentDocumentThumb.attr('data-student-document', id)
    $(e.currentTarget).before($studentDocumentThumb)

    $documentsBlock = $(e.currentTarget).parent().parent()
    $studentDocument = $(@.studentDocumentTemplate.replace(new RegExp('__id__', 'g'), id))
    $studentDocument.attr('data-student-document', id)
    $documentsBlock.append($studentDocument)
    $studentDocument.find('.selectordie').selectOrDie()
    $studentDocument.customForm()
    @.initStudentDocumentUploader($studentDocument)

    documentType = $studentDocument.find('.js-student-document-type > option:selected').text()
    $studentDocumentThumb.find('.course_block_inner').find('span:first').text(documentType)

    @.changeDocumentThumbTitle($studentDocument, $studentDocumentThumb)
    @.selectstudentDocument($studentDocumentThumb)

  clickOnStudentDocument: (e)->
    @.selectstudentDocument($(e.currentTarget))

  changeDocumentType: (e)->
    $studentDocument = $(e.currentTarget).closest('.add_ctn')

    if $(e.currentTarget).val() == 'other_document'
      $studentDocument.find('.js-title-blocks').show()
    else
      $studentDocument.find('.js-title-blocks').hide()

    studentDocumentId = $studentDocument.attr('data-student-document')
    @.changeDocumentThumbTitle($studentDocument, $('.course_block[data-student-document="' + studentDocumentId + '"]'))

  changeDocumentTitle: (e)->
    $studentDocument = $(e.currentTarget).closest('.add_ctn')
    studentDocumentId = $studentDocument.attr('data-student-document')
    @.changeDocumentThumbTitle($studentDocument, $('.course_block[data-student-document="' + studentDocumentId + '"]'))

  selectstudentDocument: ($studentDocumentThumb)->
    $educationLevels = $studentDocumentThumb.parent()
    $studentDocumentThumb.parent().find('.course_block').removeClass('course_block__current')
    $studentDocumentThumb.addClass('course_block__current')

    $documentsBlock = $studentDocumentThumb.parent().parent()
    $documentsBlock.find('.add_ctn').hide()
    studentDocumentId = $studentDocumentThumb.attr('data-student-document')
    $documentsBlock.find('.add_ctn').hide()
    $documentsBlock.find('.add_ctn[data-student-document="' + studentDocumentId + '"]').show()

  changeDocumentThumbTitle: ($studentDocument, $studentDocumentThumb)->
    title = $studentDocument.find('.js-student-document-title').val()
    if !title || title.length == 0
      title = $studentDocument.find('.js-student-document-type > option:selected').text()
    $studentDocumentThumb.find('.course_block_inner').find('span:first').text(title)

  editComment: (e)->
    $textarea = $(e.currentTarget).closest('.comment-nested-fields').find('textarea')
    $textarea.addClass('add-comments__focus')
    $textarea.removeAttr('readonly')
    $(e.currentTarget).remove()
    false

new EditUserForm()