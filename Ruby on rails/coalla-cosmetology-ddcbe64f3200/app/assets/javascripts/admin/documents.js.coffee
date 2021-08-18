$ ->
  $('#add-file-btn').fileupload
    url: Routes.admin_documents_path()
    dataType: 'json'
    singleFileUploads: false
    done: (e, data)->
      window.location = data.result.redirect_url

