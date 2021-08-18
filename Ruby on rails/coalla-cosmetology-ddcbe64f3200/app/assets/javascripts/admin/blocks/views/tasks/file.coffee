B.FileView = Backbone.View.extend
  template: _.template($('#task-file-template').html())
  events:
    'change .js-max-attempts-count': 'updateMaxAttemptsCount'
    'change .js-description': 'updateDescription'
    'change .js-final-task': 'updateFinal'

  updateMaxAttemptsCount: (event)->
    @model.set('max_attempts_count', event.target.value)

  updateDescription: (event)->
    @model.set('description', event.target.value)

  updateFinal: (event)->
    if event.target.checked
      @model.set('final', true)
    else
      @model.set('final', false)

  render: ->
    @$el.html(@template(@model.toJSON()))
