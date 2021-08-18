#=require ./base_form
PracticeBasesForm = Views.BaseForm.extend
  el: '#practice_basis_form'

  events:
    'ajax:success': 'afterSave'

  initialize: ->
    initBankAutocomplete()

    $('.js-form').customForm()

    $('.js-medical-license-file').fileupload
      url: Routes.admin_private_file_path()
      dataType: 'json'
      type: 'POST'
      paramName: 'file'
      formData: {}
      replaceFileInput: false
      done: (e, data)->
        $('[data-medical-license-cache]').val(data.result.cache)
        $('[data-remove-medical-license]').val('0')
        $('[data-placeholder] > p').text(data.result.filename)
        $('.js-medical-license-destroy').show()
        $(@).val('')

    $('.js-medical-license-destroy').click ->
      $('[data-remove-medical-license]').val('1')
      $('[data-placeholder] > p').text('Загрузить')
      $('.js-medical-license-download').remove()
      $('.js-medical-license-destroy').hide()

new PracticeBasesForm()