B.QuestionView = Backbone.View.extend
  className: 'js-current-question'
  template: _.template($('#task-test-question-template').html())
  events:
    'change .js-question-title': 'updateTitle'
    'click .js-add-answer-btn' : 'addAnswer'

  initialize: ->
    @listenTo(@model.answers, 'add', @answerAdded);

  updateTitle: (event)->
    @model.set('title', event.target.value)

  render: ->
    @$el.html(@template(@model.toJSON()))

    @.$el.customForm();
    question = @model
    @$('.js-image-upload').fileupload
      url: Routes.admin_question_image_path()
      dataType: 'json'
      type: 'POST'
      formData: {}
      replaceFileInput: false
      paramName: 'file'
      done: (e, data)->
        error = data.result.error
        if error
          alert(error)
        else
          question.set('image_cache', data.result.cache)
          question.set('image_name', data.result.filename)

    @model.answers.each(@answerAdded, @)
    @

  addAnswer: ->
    @model.addAnswer()

  answerAdded: (answer)->
    correct = @model.answers.indexOf(answer) == 0
    answerView = new B.AnswerView(model: answer, correct: correct)
    @$(".js-answer-list").append(answerView.render().el)
