$ ->
  ExpulsionOrderForm = Backbone.View.extend
    el: '#expulsion_order_form'

    events:
      'cocoon:after-insert .js-expelled-students': 'insertFields'

    initialize: ->
      initDatepicker(@.$el.find('.js-datepicker'))

    insertFields: (e, insertedItem)->
      insertedItem.find('.selectordie').selectOrDie()
      
  new ExpulsionOrderForm()