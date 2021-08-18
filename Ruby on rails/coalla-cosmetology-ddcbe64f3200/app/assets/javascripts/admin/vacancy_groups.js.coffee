$ ->
  VacancyForm = Backbone.View.extend
    el: '#vacancy_group_form'

    events:
      'change .js-content-type-select': 'onContentTypeSelect'
      'cocoon:after-insert .js-vacancies': 'insertFields'

    initialize: ->
      $('.js-vacancies').sortable({
        items: '.nested-fields'
      })

      @.initFileUpload(@.$el)

    onContentTypeSelect: (e)->
      element = $(e.target)
      if element.val() == 'text'
        element.closest('.nested-fields').find('.js-content-block').show()
        element.closest('.nested-fields').find('.js-file-block').hide()
      else
        element.closest('.nested-fields').find('.js-file-block').show()
        element.closest('.nested-fields').find('.js-content-block').hide()

    insertFields: (e, insertedItem)->
      insertedItem.customForm();
      insertedItem.find('.selectordie').selectOrDie();
      @.initFileUpload(insertedItem)

    initFileUpload: ($el) ->
      $el.find('.js-pdf-file-input').fileupload
        url: Routes.admin_pdf_path()
        dataType: 'json'
        type: 'POST'
        paramName: 'file'
        formData: {}
        replaceFileInput: false
        done: (e, data) ->
          if data.result.error
            alert data.result.error
            return
          $userFile = $(this).closest('.form_file')
          $userFile.find('[data-file-cache]').val data.result.cache
          $userFile.find('.form_file_inner').text data.result.filename
          return
      return


  new VacancyForm()