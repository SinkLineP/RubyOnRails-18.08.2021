#= require vendor/select2.full.min
#=require ./base_form
ClassroomForm = Views.BaseForm.extend
  el: '#classroom_form'

  events:
    'ajax:success': 'afterSave'
    'cocoon:before-insert .grid': 'insertFields'

  initialize: ->
    @.$el.find('.js-select2').select2()
    $('.js-form').customForm();

  insertFields: (e, $insertedItem)->
    $insertedItem.find('.js-select2').select2()

new ClassroomForm()