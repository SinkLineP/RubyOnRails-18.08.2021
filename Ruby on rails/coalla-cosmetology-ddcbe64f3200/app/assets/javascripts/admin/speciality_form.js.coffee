#=require ./base_form
SpecialityForm = Views.BaseForm.extend
  el: '#speciality_form'

  events:
    'ajax:success': 'afterSave'

  initialize: ->
    $('.js-form').customForm();

new SpecialityForm()