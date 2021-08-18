$ ->
  $('.js-activities-more').click ->
    $('#student-activities').find('.grid_i:hidden').slice(0, 40).show();
    $('.js-activities-more').hide() if $('#student-activities').find('.grid_i:hidden').length == 0
    return false

$(document).on 'change', '.js-mark', ->
  $input = $(@)
  mark = $input.val()
  return unless mark
  $.post $input.data('url'),
    mark: mark
    _method: 'PATCH'
  , (data) ->
    $input.val(data.mark)
    alert 'Оценка сохранена!'
    window.location.reload()

$(document).on 'change', '.js-result-comment', ->
  $input = $(@)
  comment = $input.val()
  return unless comment
  $.post $input.data('url'),
    comment: comment
    _method: 'PATCH'
  , () ->
    alert 'Комментарий сохранен!'

$(document).on 'click', '.js-notify-about-result-comment', ->
  $input = $(@)
  comment = $input.closest('.grid').find('.js-result-comment').val()
  unless comment
    alert 'Введите комментарий!'
    return
  $.post $input.data('url'),
    comment: comment
  , () ->
    alert 'Комментарий отправлен!'