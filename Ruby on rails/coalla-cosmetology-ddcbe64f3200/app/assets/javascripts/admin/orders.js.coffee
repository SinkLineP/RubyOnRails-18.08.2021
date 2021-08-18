#= require ./base_form
$ ->
  $('.js-autocomplete-blocks').autocomplete
    minLength: 3
    source: Routes.list_admin_blocks_path()
    appendTo: $('.autocomplete_variants.js-blocks-variants')

    open: ->
      $(this).addClass('open')

    select: (e, ui) ->
      if !ui.item
        $(this).val('')
        return false

      if $('[data-block-id][value="' + ui.item.id + '"]').length > 0
        $(this).val('')
        return false

      $block = $($('#block_template').html())
      $('.js-blocks-list').find('.course_block__add').before($block)
      $block.find('[data-block-id]').val(ui.item.id)
      $block.find('[data-edit-block-link]').attr('href', ui.item.link).text(ui.item.value)
      $(this).val('')
      return false

  GroupSubscriptionForm = Views.BaseForm.extend
    el: '#group_subscription_form'

    events:
      'click .js-remove-block': 'removeBlock'

    initialize: ->
      @.initBlocksAutocomplete()

  new GroupSubscriptionForm()