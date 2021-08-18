$ ->
  $('.form_file_tag').fileupload
    url: Routes.admin_pdf_path()
    dataType: 'json'
    singleFileUploads: false
    type: 'POST'
    formData: {}
    paramName: 'file'
    done: (e, data)->
      if data.result.error
        alert(data.result.error)
        return
      $('#pdf').closest('.form_file').attr('placeholder', data.result.filename)
      $('#pdf_cache').val(data.result.cache)