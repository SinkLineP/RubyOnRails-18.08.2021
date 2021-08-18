# Загрузка материалов для скачивания в лекции
# @see app/assets/javascripts/admin/blocks/views/lecture_body.js.coffee
module Admin
  class DownloadsController < AdminController
    def create
      uploader = DownloadFileUploader.new
      uploader.cache! params[:file]
      render json: { url: uploader.url, filename: uploader.filename, extension: uploader.file.extension.upcase, cache: uploader.cache_name }
    rescue => ex
      render json: { error: upload_error(ex) }
    end
  end
end