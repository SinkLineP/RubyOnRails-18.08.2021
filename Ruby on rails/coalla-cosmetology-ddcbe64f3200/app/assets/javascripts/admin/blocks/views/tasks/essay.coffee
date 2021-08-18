B.EssayView = Backbone.View.extend
  template: _.template($('#task-essay-template').html())
  events:
    'change .js-max-answer-length': 'updateMaxAnswerLength'
    'change .js-max-attempts-count': 'updateMaxAttemptsCount'
    'change .js-description': 'updateDescription'
    'change .js-final-task': 'updateFinal'

  render: ->
    @$el.html(@template(@model.toJSON()))

  updateMaxAnswerLength: (event)->
    @model.set('max_answer_length', event.target.value)

  updateMaxAttemptsCount: (event)->
    @model.set('max_attempts_count', event.target.value)

  updateDescription: (event)->
    @model.set('description', event.target.value)

  updateFinal: (event)->
    if event.target.checked
      @model.set('final', true)
    else
      @model.set('final', false)
