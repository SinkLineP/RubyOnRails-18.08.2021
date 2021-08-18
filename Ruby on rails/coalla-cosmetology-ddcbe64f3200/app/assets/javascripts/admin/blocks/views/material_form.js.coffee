B.MaterialFormView = Backbone.View.extend
  className: 'grid_i grid_i__grid-1-1'
  template: _.template($('#material-form-template').html())

  initialize: (material)->
    @.material = material
    @.render()

    if @.material.get('type') == 'ScribdMaterial'
      @$('.form_file_tag').fileupload
        url: Routes.admin_material_cover_path()
        dataType: 'json'
        singleFileUploads: false
        type: 'POST'
        formData: {}
        paramName: 'file'
        done: (e, data)->
          material.set('cover_file_url', data.result.preview_url)
          material.set('cover_file_name', data.result.file_name)
          material.set('cover_cache', data.result.cache)
    else
      @$('.form_file_tag').fileupload
        url: Routes.admin_pdf_path()
        dataType: 'json'
        singleFileUploads: false
        type: 'POST'
        formData: {}
        paramName: 'file'
        done: (e, data)->
          if data.result.error
            alert(data.result.error)
            return
          material.set('pdf_filename', data.result.filename)
          material.set('pdf_cache', data.result.cache)

  render: ->
    @.$el.html(@.template(@.material.toJSON()))
    @.$el.customForm();

  pushState: ->
    @.material.set('name', @.$('.js-field-name').val())
    @.material.set('time', @.$('.js-field-time').val())
    @.material.set('link', @.$('.js-field-link').val())
    @.material.set('required', @.$('.js-field-required').is(':checked'))