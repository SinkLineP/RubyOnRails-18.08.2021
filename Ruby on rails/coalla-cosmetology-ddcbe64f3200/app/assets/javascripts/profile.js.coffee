$ ->
  ProfileForm = Backbone.View.extend
    el: '.profile_edit'

    events:
      'click .js-remove-document-copy': 'removeDocumentCopy'
      'click .js-remove-student-document': 'removeStudentDocumentCopy'
      'change .js-student-document-type .selectordie': 'changeDocumentType'
      'cocoon:after-insert .js-copies': 'insertFields'
      'cocoon:after-insert .js-document-copies': 'insertFields'

    initialize: ->
      @.studentDocumentTemplate = $('#student_document_template').html()
      @.initFileUpload(@.$el)
      @.initStudentDocumentUploader(@.$el)

    insertFields: (e, insertedItem)->
      @.$el.customForm();
      @.initFileUpload(insertedItem)
      @.initStudentDocumentUploader(insertedItem)
      @.initSelectOrDie(insertedItem)

    removeDocumentCopy: (e)->
      $(e.currentTarget).closest('.js-document-copy-block').find('[data-destroy]').val('1')
      $(e.currentTarget).closest('.js-document-copy-block').hide()

    removeStudentDocumentCopy: (e)->
      $(e.currentTarget).closest('.js-student_document').find('[data-destroy]').val('1')
      $(e.currentTarget).closest('.js-student_document').hide()

    changeDocumentType: (e)->
      $studentDocument = $(e.currentTarget).closest('.js-student_document')

      if $(e.currentTarget).val() == 'other_document'
        $studentDocument.find('.js-file-block').removeClass('grid_i__grid-3-4').addClass('grid_i__grid-2-4')
        $studentDocument.find('.js-title-blocks').show()
      else
        $studentDocument.find('.js-title-blocks').hide()
        $studentDocument.find('.js-file-block').removeClass('grid_i__grid-2-4').addClass('grid_i__grid-3-4')


    initSelectOrDie: ($el)->
      $el.find('.selectordie').selectOrDie()

     initFileUpload: ($el) ->
      $('.js-profile-document-copy').fileupload
        url: Routes.private_file_path()
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
          $(@).closest('.grid').find('.js-document-copies').append($documentCopy)
          $documentCopy.find('[data-cache]').val(data.result.cache)
          $documentCopy.find('[data-destroy]').val('0')
          $documentCopy.find('[data-extension]').text(data.result.extension)
          $documentCopy.find('[data-filename]').text(data.result.filename)
          $(@).val('')

    initStudentDocumentUploader: ($el)->
      $('.js-student-document-file').fileupload
        url: Routes.private_file_path()
        dataType: 'json'
        type: 'POST'
        formData: {}
        paramName: 'file'
        done: (e, data)->
          if data.result.error
            alert(data.result.error)
            return

          $studentDocument = $(@).closest('.js-student_document')
          $studentDocument.find('[data-document-cache]').val(data.result.cache)
          $studentDocument.find('.form_file_inner').text(data.result.filename)
          studentDocumentId = $studentDocument.attr('data-student-document')
          $('.course_block[data-student-document="' + studentDocumentId + '"]').find('span:last').text('(' + data.result.filename + ')')

  new ProfileForm()