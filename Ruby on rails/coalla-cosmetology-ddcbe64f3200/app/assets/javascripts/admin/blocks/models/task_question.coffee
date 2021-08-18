B.TaskQuestion = Backbone.Model.extend
  defaults:
    title: ''
    for_edit: false
    image_name: ''
    image_cache: ''

  initialize: (json = {}) ->
    @answers = new B.TaskQuestionAnswers(json.question_answers)

  toJSON: ->
    json = _(@.attributes).clone()
    json.question_answers_attributes = @answers.toJSON()
    delete json['question_answers']
    json

  addAnswer: ->
    answer = new B.TaskQuestionAnswer()
    @answers.add(answer)

  correctAnswer: ->
    @answers.at(0).get('title')

  otherAnswers: ->
    titles = @answers.map( (answer)->
        answer.get('title')
      , @)
    _.rest(titles, 1).join(',')

B.TaskQuestions = Backbone.Collection.extend
  model: B.TaskQuestion