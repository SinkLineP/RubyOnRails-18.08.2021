$ ->
  $('.js-create-course').click ->
    block_ids = []
    $('.js-block:checked').each (idx, el) ->
      block_ids.push($(el).data('id'))

    if !_.isEmpty(block_ids)
      $(this).attr('href', Routes.new_admin_course_path({course: {block_ids: block_ids}}))
    else
      alert('Необходимо выбрать блоки.')
      return false

  $('.js-clone-block').on 'ajax:success', (e, response) ->
    alert('Клонирование блока запущено. По его завершении Вы получите письмо.')

  $('.js-clone-block').on 'ajax:error', (e, response) ->
    alert('Извините. Произошла ошибка.');