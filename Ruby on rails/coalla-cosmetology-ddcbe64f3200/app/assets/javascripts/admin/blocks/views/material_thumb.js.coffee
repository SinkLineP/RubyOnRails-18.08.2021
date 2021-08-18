B.MaterialThumbView = Backbone.View.extend
  className: 'grid_i grid_i__grid-1-12'
  template: _.template($('#material-thumb-template').html())

  events:
    'click .js-book': 'selectMaterial'
    'click .icon_del': 'removeMaterial'

  initialize: (material)->
    @material = material
    @listenTo(@material, 'change:cover_file_url', @render)
    @render()

  render: ->
    @.$el.html(@.template(@.material.toJSON()))

  selectMaterial: ->
    @.trigger('material:select', @.material)
    false

  removeMaterial: ->
    collection = @.material.collection
    collection.remove(@.material)
    @.remove()
    false