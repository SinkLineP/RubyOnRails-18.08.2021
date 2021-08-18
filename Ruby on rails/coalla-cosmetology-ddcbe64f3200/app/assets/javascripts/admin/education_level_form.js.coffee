#=require ./base_form
EducationLevelForm = Views.BaseForm.extend
  el: '#education_level_form'

  events:
    'ajax:success': 'afterSave'

  initialize: ->
    @.initSelectOrDie(@.$el)
    $('.js-form').customForm();

new EducationLevelForm()