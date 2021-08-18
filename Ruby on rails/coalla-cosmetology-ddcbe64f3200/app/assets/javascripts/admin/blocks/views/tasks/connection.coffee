B.ConnectionView = Backbone.View.extend
  template: _.template($('#task-connection-template').html())
  events:
    'change .js-max-attempts-count': 'updateMaxAttemptsCount'
    'change .js-time-limit': 'updateTimeLimit'
    'change .js-description': 'updateDescription'
    'change .js-column-title': 'updateColumnTitle'
    'change .js-column-variant-title': 'updateColumnVariantTitle'
    'change .js-final-task': 'updateFinal'

  initialize: ->
   unless @model.id && @model.columns && @model.columns.length == 3
     @model.initColumns()

  updateMaxAttemptsCount: (event)->
    @model.set('max_attempts_count', event.target.value)

  updateTimeLimit: (event)->
    @model.set('time_limit', event.target.value)

  updateDescription: (event)->
    @model.set('description', event.target.value)

  updateColumnTitle: (event)->
    $target = $(event.target)
    value = $target.val()
    index = $target.attr('data-index')
    @model.columns.at(index).set('title', value)

  updateColumnVariantTitle: (event)->
    $target = $(event.target)

    column_index = $target.attr('data-column-index')
    column = @model.columns.at(column_index)

    variant_index = $target.attr('data-variant-index')
    variant = column.variants.at(variant_index)

    value = $target.val()
    variant.set('title', value)

  updateFinal: (event)->
    if event.target.checked
      @model.set('final', true)
    else
      @model.set('final', false)

  render: ->
    @$el.html(@template(@model.toJSON()))
    columns = @model.columns
    @$('.js-image-variant-upload').fileupload
      url: Routes.admin_column_variant_images_path()
      dataType: 'json'
      type: 'POST'
      formData: {}
      replaceFileInput: false
      paramName: 'file'
      done: (e, data)->
        error = data.result.error
        if error
          $(@).closest('.js-image-upload-container').find('.js-form_el_inner').text('Добавить изображение')
          alert(error)
        else
          column_index = $(@).attr('data-column-index')
          column = columns.at(column_index)
          column.variants.add({title: data.result.filename, image_cache: data.result.cache})
          $('<div class="form_el js-form_el form_tx"><span class="form_el_tag form_tx_tag tx-left">' + data.result.filename + '</span></div>').insertBefore($(@).closest('.js-image-upload-container'));
          $(@).closest('.js-image-upload-container').find('.js-form_el_inner').text('Добавить изображение')
