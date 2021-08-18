#=require ./images
#=require ./base_form
$ ->
  EditSquareBannerForm = Views.BaseForm.extend
    el: '#square_banner_form'

    events:
      'click .js-remove-block': 'removeBlock'

    initialize: ->
      initImageUpload()
      @.initBlocksAutocomplete()

  new EditSquareBannerForm()