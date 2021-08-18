B.TasksFormView = Backbone.View.extend

  initialize: (options) ->
    @taskTypeSelector = options.selector
    @taskTypeSelectorView = options.selectorView
    @listenTo(@taskTypeSelector, 'change:taskType', @render);

    @tasks = {}
    TASK_TYPES = ['TextTask', 'TestTask', 'FileTask', 'EssayTask', 'ConnectionTask', 'CalculationTask']
    _.each(TASK_TYPES, (type)->
      @tasks[type] = @fetchTask(type, options.task)
    , @)
      
    new B.TextView(el: @$('[data-task-type=TextTask]') , model: @tasks['TextTask']).render()
    new B.TestView(el: @$('[data-task-type=TestTask]') , model: @tasks['TestTask']).render()
    new B.FileView(el: @$('[data-task-type=FileTask]') , model: @tasks['FileTask']).render()
    new B.EssayView(el: @$('[data-task-type=EssayTask]') , model: @tasks['EssayTask']).render()
    new B.ConnectionView(el: @$('[data-task-type=ConnectionTask]') , model: @tasks['ConnectionTask']).render()
    new B.CalculationView(el: @$('[data-task-type=CalculationTask]') , model: @tasks['CalculationTask']).render()

    @render()

  fetchTask: (type, task) ->
    if task and type == task.get('type')
      task
    else
      new B.Task({type: type})
      
  getActiveTask: ->
    type = @taskTypeSelector.get('taskType')
    @tasks[type]
    
  render: ->
    @$('.js-task.open').removeClass('open')
    @$(".js-task[data-task-type=#{@taskTypeSelector.get('taskType')}]").addClass('open')
    @positionArrow()

  positionArrow: ->
    $menu_item = @taskTypeSelectorView.$el.find(".js-exercise[data-task-type=#{@taskTypeSelector.get('taskType')}]")
    position = $menu_item.offset().left - @$el.offset().left + $menu_item.outerWidth() / 2
    @$('.js-task-arrow').stop().animate({'left': position}, 400);
