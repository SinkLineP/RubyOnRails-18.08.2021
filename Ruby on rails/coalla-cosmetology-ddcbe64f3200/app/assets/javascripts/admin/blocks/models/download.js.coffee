B.Download = Backbone.Model.extend
  defaults:
    filename: ''
    extension: ''
    url: ''
    cache: ''

B.Downloads = Backbone.Collection.extend
  model: B.Download