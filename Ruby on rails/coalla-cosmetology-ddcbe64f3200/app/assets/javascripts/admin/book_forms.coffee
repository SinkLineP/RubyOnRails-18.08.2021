(new CatAutocomp).attachToForm '.js-new-book-form'

$(document)
.on 'ajax:success', '.js-book-form', (_, data) ->
  if data.status is 'ok'
    window.location = Routes.admin_books_path()
  else
    showErrors $(this), data.errors
.on 'ajax:error', '.js-book-form', ->
  alert 'Возникла ошибка'
.on 'keydown change', '.js-book-form input, textarea', ->
  hideError this
.on 'click', '.js-book-form .autocomplete_variants', ->
  hideError '.js-book-form .js-book_category_id-container'
.on 'click', '.js-book-form .js-file-input', ->
  hideError '.js-book-form .js-cover-container'

showErrors = (form, errors) ->
  $(form).find('[data-valid]').attr('data-valid', '')

  _.each errors, (value, key) ->
    showError form, key, value.join(', ')

showError = (form, el_name, error_text) ->
  $('.js-' + el_name + '-container', form).attr('data-valid', 'false').attr('title', error_text)

hideError = (el) ->
  $(el).closest('[data-valid]').attr('data-valid', '')

truncate = (string, length = 30) ->
  truncation = '...'
  if string.length > length then string.slice(0, length - (truncation.length)) + truncation else String(string)

@setBtnText = (form, text) ->
  $(form).find('[data-filename]').text(truncate(text))

@initCoverUpl = () ->
  $('.js-cover-file-input').fileupload
    url: Routes.cover_create_admin_books_path()
    dataType: 'json'
    type: 'POST'
    formData: {} # to be rails-POST
    singleFileUploads: false
    done: (e, data)->
      $('.js-cover-cache').val data.result.coverCache
      setBtnText $(this).closest('form'), data.result.coverFilename

@initCoverUpl()

@initPdfUpl = () ->
  $('.js-pdf-file-input').fileupload
    url: Routes.admin_pdf_path()
    dataType: 'json'
    type: 'POST'
    paramName: 'file'
    formData: {} # to be rails-POST
    singleFileUploads: false
    done: (e, data)->
      $('.js-pdf-cache').val data.result.cache
      setBtnText $(this).closest('form'), data.result.filename

@initPdfUpl()

$(document).on 'beforeOpen', '#new_book', ->
  $('[data-valid]').attr('data-valid', '')

$(document).on 'change', '#book_type', ->
  bookType = $(@).val()
  if bookType == 'PdfBook'
    $('.js-pdf-fields').show()
    $('.js-scribd-fields').hide()
  else
    $('.js-pdf-fields').hide()
    $('.js-scribd-fields').show()