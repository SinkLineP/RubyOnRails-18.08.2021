B.TaskColumn = Backbone.Model.extend
  defaults:
    title: ''

  initialize: (json = {}) ->
    @variants = new B.TaskColumnVariants(json.column_variants)

  toJSON: ->
    json = _(@.attributes).clone()
    json.column_variants_attributes = @variants.toJSON()
    delete json['column_variants']
    json

B.TaskColumns = Backbone.Collection.extend
  model: B.TaskColumn