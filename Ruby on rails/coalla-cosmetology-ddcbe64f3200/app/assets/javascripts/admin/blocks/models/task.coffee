B.Task = Backbone.Model.extend
  defaults:
    id: ''
    type: 'TestTask'
    title: ''
    description: ''
    answer: ''
    max_answer_length: ''
    max_attempts_count: ''
    max_answer_length: ''
    items_count: ''
    time_limit: ''
    final: false

  initialize: (json = {}) ->
    @columns = new B.TaskColumns(json.columns)
    @questions = new B.TaskQuestions(json.questions)

  initColumns: ->
    @columns.add(@initColumnsJSON())

  initColumnsJSON: ->
    _.map(_.range(3 - @columns.length), ->
      @initColumnJSON()
    , @)

  initColumnJSON: ->
    {title: '', column_variants: @initColumnVariantsJSON()}

  initColumnVariantsJSON: ->
    _.map(_.range(10), ->
      {title: ''})

  toJSON: ->
    json = _(@.attributes).clone()
    json.columns_attributes = @columns.toJSON()
    delete json['columns']
    json.questions_attributes = @questions.toJSON()
    delete json['questions']
    json