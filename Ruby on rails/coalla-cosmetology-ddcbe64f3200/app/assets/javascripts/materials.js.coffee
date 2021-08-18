$ ->
  $('[data-mark-as-finished]').on 'ajax:success', ->
    $this = $(this)
    $this.closest('.book_status').removeAttr('data-disabled')
    $this.closest('.book').addClass('read')
    $this.remove()

  $('.book_status').click (e) ->
    $form = $(this).find('form')

    if $form.attr('data-disabled')
      return

    $form.attr('data-disabled', true)
    $form.submit()