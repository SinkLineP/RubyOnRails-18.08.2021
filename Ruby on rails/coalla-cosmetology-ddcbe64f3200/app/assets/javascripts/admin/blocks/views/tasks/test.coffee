B.TestView = Backbone.View.extend
  template: _.template($('#task-test-template').html())
  events:
    'click .js-add-question-btn' : 'addQuestion'
    'change .js-final-task': 'updateFinal'
    'change .js-max-attempts-count': 'updateMaxAttemptsCount'
    'change .js-time-limit': 'updateTimeLimit'
    'change .js-items-count': 'updateItemsCount'

  initialize: ->
    @listenTo(@model.questions, 'add', @questionAdded);
    @initCurrentQuestionView()

  initCurrentQuestionView: ->
    @questionView = new B.QuestionView
      model: @initCurrentQuestion()

  initCurrentQuestion: ->
    new B.TaskQuestion
      title: ''
      question_answers:[
        {title: ''}
        {title: ''}
      ]

  updateMaxAttemptsCount: (event)->
    @model.set('max_attempts_count', event.target.value)

  updateItemsCount: (event)->
    @model.set('items_count', event.target.value)

  updateTimeLimit: (event)->
    @model.set('time_limit', event.target.value)

  updateFinal: (event)->
    if event.target.checked
      @model.set('final', true)
    else
      @model.set('final', false)

  render: ->
    @$el.html(@template(@model.toJSON()))
    @$('.js-current-question').replaceWith(@questionView.render().el)
    @model.questions.each((question)->
      thumbView = new B.QuestionThumbView(model: question)
      @$('.js-question-thumbs').append(thumbView.render().el)
    , @)
    @

  addQuestion: ->
    newQuestion = @questionView.model
    @model.questions.add(newQuestion)
    newQuestion.collection = @model.questions

  questionAdded: ->
    @initCurrentQuestionView()
    @render()