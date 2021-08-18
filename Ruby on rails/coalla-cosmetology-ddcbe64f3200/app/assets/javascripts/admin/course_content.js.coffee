#= require ./images
#= require ./base_form
$ ->
  CourseContentForm = Views.BaseForm.extend
    el: '#course_content_form'

    events:
      'click .js-remove-block': 'removeBlock'

    initialize: ->
      initImageUpload()
      @.initBlocksAutocomplete()

  new CourseContentForm()