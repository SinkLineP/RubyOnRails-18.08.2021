class CatAutocomp

  constructor: ->
    @position = offset: '0'
    @minLength = 0
    @source = gon.book_category_names

  attachToForm: (form) ->
    @appendTo = $(form).find('.autocomplete_variants')

    @open = ->
      $(this).addClass 'open'

    @change = ->
      $(this).autocomplete 'close'

    $(form).find('.autocomplete_users').autocomplete(this).focus ->
      $input = $(this);
      $input.autocomplete("search", $input.val());


@CatAutocomp = CatAutocomp
