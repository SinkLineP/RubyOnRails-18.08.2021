#= require ./images
class CatAutocomp

  constructor: ->
    @position =
      offset: '0'
    @minLength = 0
    @source = Routes.admin_post_categories_path()
    initImageUpload()

  attachToForm: (form) ->
    @appendTo = $(form).find('.autocomplete_variants')

    @open = ->
      $(this).addClass 'open'

    @create = ->
      $(this).autocomplete 'search', ''

    @change = ->
      $(this).autocomplete 'close'

    $(form).find('.autocomplete_categories').autocomplete this


@CatAutocomp = CatAutocomp

$ ->
  (new CatAutocomp).attachToForm '.js-post-form'