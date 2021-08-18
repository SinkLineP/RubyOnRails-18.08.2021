window.initImageUpload = ->
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
        return false
      error: ->
        alert 'Произошла ошибка при обращении к серверу.'
        return false
    return