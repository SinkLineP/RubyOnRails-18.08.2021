B.TaskColumnVariant = Backbone.Model.extend
  defaults:
    title: ''

B.TaskColumnVariants = Backbone.Collection.extend
  model: B.TaskColumnVariant