#= require ./base_form
$ ->
  RecallForm = Views.BaseForm.extend
    el: '#recall_form'

    events:
      'click .js-remove-block': 'removeBlock'

    initialize: ->
      @.initBlocksAutocomplete()

  new RecallForm()