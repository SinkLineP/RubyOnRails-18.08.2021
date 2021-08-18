B.TaskQuestionAnswer = Backbone.Model.extend
  defaults:
    title: ''

B.TaskQuestionAnswers = Backbone.Collection.extend
  model: B.TaskQuestionAnswer