$ ->
  $('.js-drop_ctn').sortable
    items: '.drop-i'
    connectWith: '.drop_ctn'
    stop: (e, ui) ->
      $item = $(ui.item)
      $dropArea = $(ui.item).closest('.js-drop_ctn')
      if $dropArea.hasClass('js-column')
        columnId = $dropArea.data('column-id')
        $item.find('[name$=\'[column_id]\']').val(columnId)

      if $('.js-drop_ctn:not(.js-column) > .drop-i').length == 0
        $(':submit').removeAttr('disabled').closest('.form_el').removeAttr('disabled')
      else
        $(':submit').attr('disabled', 'disabled').closest('.form_el').attr('disabled', 'disabled')
  return