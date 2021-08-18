#= require ./base_form
$ ->
  PromoCodeForm = Views.BaseForm.extend
    el: '#promo_code_form'

    events:
      'click .js-remove-block': 'removeBlock'
      'click .js-generate': 'generateCode'

    initialize: ->
      initDatepicker()
      @.initBlocksAutocomplete()

    generateCode: (e)->
      chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'

      randChars = _.times 6, ->
        i = Math.floor(Math.random() * chars.length)
        return chars.charAt(i)

      $(e.currentTarget).closest('.admin_header').find('#promo_code_code').val(randChars.join(''))

  new PromoCodeForm()