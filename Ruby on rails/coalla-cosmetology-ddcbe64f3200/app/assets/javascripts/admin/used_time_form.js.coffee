#=require ./base_form
#=require ./used_time_calculations
UsedTimeForm = Views.BaseForm.extend
  el: '#used_time_form'

  events:
    'ajax:success': 'afterSave'
    'change .js-used-date': 'updatePossibleTimes'

  initialize: ->
    $('.js-form').customForm();
    initDatepicker();
    @.initSelectOrDie(@.$el)

  updatePossibleTimes: (e)->
    $this = $(e.currentTarget)
    $timesSelect = $('.js-used-time')

    UsedTime.updatePossibleTimes($this, $timesSelect, null)


new UsedTimeForm()