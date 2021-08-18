B.Material = Backbone.Model.extend
  defaults:
    name: ''
    time: ''
    link: ''
    required: false
    cover_file_url: ''
    cover_file_name: ''
    cover_cache: ''
    pdf_filename: ''
    pdf_cache: ''
    type: 'ScribdMaterial'
    pdf_editable: true

B.Materials = Backbone.Collection.extend
  model: B.Material