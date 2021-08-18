#=require ./base_form
AdvantageForm = Views.BaseForm.extend
  el: '#advantage_form'

  events:
    'ajax:success': 'afterSave'

  initialize: ->
    $('.js-form').customForm();

new AdvantageForm()