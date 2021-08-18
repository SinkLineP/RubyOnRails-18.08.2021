$ ->
  $('[data-valid="false"]').each ->
    $this = $(this)
    errors = $this.data('errors')
    $el = if $this.hasClass('selectordie') then $this.closest('.sod_select') else $this.closest('.form_el')
    $el.attr('data-valid', 'false').attr('title', errors)