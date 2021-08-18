#= require vendor/select2.full.min

$ ->
  SubscriptionContractForm = Backbone.View.extend
    el: '#subscription_contract_form'

    events:
      'cocoon:after-insert .js-working-off-lists': 'insertFields'

    initialize: ->
      initDatepicker()
      initBankAutocomplete()
      initFileUpload()
      @.$el.find('.js-course-select2').select2()
      @.$el.find('input:checkbox').customForm()

    insertFields: (e, insertedItem)->
      insertedItem.find('.selectordie').selectOrDie()
      insertedItem.find('.js-course-select2').select2()
      insertedItem.find('input:checkbox').customForm()
      @.initDatePicker(insertedItem)

    initDatePicker: ($el)->
      initDatepicker($el.find('.js-datepicker'))

  new SubscriptionContractForm()