B.PdfView = Backbone.View.extend
  className: 'grid_i grid_i__middle grid_i__grid-1-2'
  template: _.template($('#pdf-template').html())

  events:
    'click .icon_del': 'removePdf'

  initialize: (options)->
    @model = options.model
    @view = options.view

  render: ->
    @$el.html(@template(@model))

  removePdf: (e)->
    @view.removePdf()
    $(e.target).closest('.material-a').parent().remove()
