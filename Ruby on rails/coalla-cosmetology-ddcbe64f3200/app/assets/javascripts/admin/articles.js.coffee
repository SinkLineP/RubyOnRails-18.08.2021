#= require ./base_form
$ ->
  ArticleForm = Views.BaseForm.extend
    el: '#article_form'

    events:
      'click .js-remove-block': 'removeBlock'

    initialize: ->
      @.initBlocksAutocomplete()

  new ArticleForm()

  $('.js-add-image-btn').change ->
    $addImageButton = $(this)
    formData = new FormData
    formData.append 'image', @files[0]
    formData.append 'uploader', $addImageButton.data('uploader')
    formData.append 'version', $addImageButton.data('version')
    $.ajax
      url: Routes.admin_images_path()
      data: formData
      method: 'POST'
      processData: false
      contentType: false
      success: (response) ->
        if response.error
          alert(response.error)
        else
          $imageBlock = $addImageButton.closest('.js-image-block');
          $imageBlock.find('img').attr('src', response.imageUrl);
          $imageBlock.find('input:hidden').val(response.imageCache);
          $('#article_remove_main_image').val('0')
        return false
      error: ->
        alert 'Произошла ошибка при обращении к серверу.'
        return false
    return

  $('.js-remove-main-image').click ->
    $('#article_remove_main_image').val('1')
    $('.js-uploaded-image').attr('src', '/assets/article_1310.png')
    return false

  $(document).on 'ajax:success', '.js-article-notify', (e, data) ->
    alert('Рассылка была успешно запущена')
    return

  $(document).on 'ajax:error', '.js-article-notify', ->
    alert('Извините. Произошла ошибка при обращении к серверу')
    return