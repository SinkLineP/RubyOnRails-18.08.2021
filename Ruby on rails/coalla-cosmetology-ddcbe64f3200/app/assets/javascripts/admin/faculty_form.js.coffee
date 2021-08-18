#=require ./base_form
FacultyForm = Views.BaseForm.extend
  el: '#faculty_form'

  events:
    'ajax:success': 'afterSave'

  initialize: ->
    $('.js-form').customForm();

new FacultyForm()