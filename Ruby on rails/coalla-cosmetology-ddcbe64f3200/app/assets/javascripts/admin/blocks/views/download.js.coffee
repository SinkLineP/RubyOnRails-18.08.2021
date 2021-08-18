B.DownloadView = Backbone.View.extend
  className: 'grid_i grid_i__middle grid_i__grid-1-2'
  template: _.template($('#download-template').html())

  events:
    'click .icon_del': 'removeDownload'

  initialize: ->
    @listenTo(@model, 'destroy', @remove);

  render: ->
    @$el.html(@template(@model.toJSON()))

  removeDownload: ->
    @model.trigger('destroy', @model, @model.collection);
