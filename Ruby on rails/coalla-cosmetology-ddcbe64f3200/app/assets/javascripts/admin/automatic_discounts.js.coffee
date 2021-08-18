#= require ./base_form
$ ->
  AutomaticDiscountForm = Views.BaseForm.extend
    el: '#automatic_discount_form'

    events:
      'click .js-remove-block': 'removeBlock'

    initialize: ->
      @.initBlocksAutocomplete()

  new AutomaticDiscountForm()