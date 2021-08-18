window.Views = {}
Views.BaseForm = Backbone.View.extend
  removeBlock: (e)->
    $(e.target).closest('.course_block').remove()

  initBlocksAutocomplete: (atocomleteSelector)->
    $('.js-autocomplete-blocks').each ->
      $autocomplete = $(@)
      $template = $($autocomplete.data('template'))
      $container = $($autocomplete.data('append-to'))

      $container.sortable
        items: '.course_block',
        cancel: 'a,.js-remove-block'

      $autocomplete.autocomplete
        minLength: 3
        source: $autocomplete.data('path')
        appendTo: $($autocomplete.data('variants'))

        open: ->
          $(this).addClass('open')

        select: (e, ui) ->
          if !ui.item
            $(this).val('')
            return false

          if $container.find('[data-block-id][value="' + ui.item.id + '"]').length > 0
            $(this).val('')
            return false

          $block = $($template.html())
          $elem = $container.find('.course_block:last')
          if $elem.length > 0
            $block.insertAfter($container.find('.course_block:last'))
          else
            $container.append($block)
          $block.find('[data-block-id]').val(ui.item.id)
          $block.find('[data-block-name]').text(ui.item.value)
          $(this).val('')
          $container.sortable('refresh')
          return false

  initDatepicker: ($el)->
    $el.find('.js-datepicker').each ->
      $(this).datepicker
        dateFormat: "dd.mm.yy",
        showAnim: 'fadeIn',
        showOtherMonths: true,
        selectOtherMonths: true,
        changeMonth: true,
        changeYear: true

  initSelectOrDie: ($el)->
    $el.find('.selectordie').selectOrDie()

  showErrors: ($form, errors)->
    $form.find('[data-valid]').removeAttr('data-valid').removeAttr('title')
    $form.find('.alert').html('').hide()
    _(errors).each (message, attr_name)->
      if attr_name == 'base'
        $form.find('.alert').append('<p>' + message.join(', ') + '</p>')
        $form.find('.alert').show()
      else
        $form.find('[name$=\'[' + attr_name + ']\'],[name$=\'' + attr_name + '\']').parent().attr('data-valid', false).attr('title', message.join(','))

  afterSave: (e, data)->
    if data.errors
      @.showErrors(@.$el, data.errors)
    else if data.successHtml
      @.$el.replaceWith(data.successHtml)
    else
      window.location = data.redirect_url