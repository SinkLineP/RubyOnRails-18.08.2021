B.AnswerView = Backbone.View.extend
  className: 'grid grid__collapse'
  template: _.template($('#task-test-answer-template').html())
  events:
    'change .js-title': 'updateTitle'

  initialize: (options)->
    @model = options.model
    @correct = options.correct

  updateTitle: (event)->
    @model.set('title', event.target.value)

  render: ->
    @$el.html(@template(@model.toJSON()))
    @
