#=require ./images
#=require ./base_form
$ ->
  GraduateForm = Views.BaseForm.extend
    el: '#graduate_form'

    initialize: ->
      initImageUpload()
      @.initBlocksAutocomplete()

  new GraduateForm()