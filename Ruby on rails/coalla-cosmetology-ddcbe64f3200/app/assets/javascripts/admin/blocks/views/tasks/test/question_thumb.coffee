B.QuestionThumbView = Backbone.View.extend
  template: _.template($('#task-test-question-thumb-template').html())
  events:
    'click .js-question-remove-btn': 'removeQuestion'
    'click .js-question-edit-btn': 'editQuestion'
    'click .js-save-question-changes-btn' : 'saveQuestionChanges'

  editQuestion: ->
    @model.attributes.for_edit = true
    questionView = new B.QuestionView
      model: @model
    @$('.js-question-edit-form').show().html(questionView.render().el)

  removeQuestion: (event)->
    @model.collection.remove(@model)
    @remove()

  render: ->
    @$el.html(@template(@model.toJSON()))
    @

  saveQuestionChanges: ->
    @render()

