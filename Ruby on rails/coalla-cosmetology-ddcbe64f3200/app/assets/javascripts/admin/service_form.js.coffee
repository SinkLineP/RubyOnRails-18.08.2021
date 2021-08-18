#=require ./base_form
ServiceForm = Views.BaseForm.extend
  el: '#service_form'

  events:
    'ajax:success': 'afterSave'

  initialize: ->
    @.initSelectOrDie(@.$el)
    $('.js-form').customForm();

new ServiceForm()