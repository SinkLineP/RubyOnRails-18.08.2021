#= require vendor/select2.full.min
#=require ./base_form
InstructorVacation = Views.BaseForm.extend
  el: '#instructor_vacation_form'

  events:
    'ajax:success': 'afterSave'

  initialize: ->
    @.$el.find('.js-select2').select2()
    @.initDatepicker(@.$el)
    $('.js-form').customForm();

new InstructorVacation()