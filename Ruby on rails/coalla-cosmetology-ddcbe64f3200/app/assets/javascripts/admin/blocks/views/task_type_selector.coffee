B.TaskTypeSelectorView = Backbone.View.extend
  events:
    'click .js-exercise': 'selectTask'

  initialize: ->
    @listenTo(@model, 'change:taskType', @render);
    @render()

  render: ->
    @$('.js-exercise.active').removeClass('active')
    @$(".js-exercise[data-task-type=#{@model.get('taskType')}]").addClass('active')

  selectTask: (event)->
    if this.model.get('taskEditable') != undefined && !@model.get('taskEditable') && !$(event.target).hasClass('active')
      alert('Нельзя изменить тип задания, так как есть студенты, которые уже прошли эту лекцию.')
      return false
    $exercise = $(event.target)
    @model.set('taskType', $exercise.data('task-type'))
    $('.js-task').customForm();
