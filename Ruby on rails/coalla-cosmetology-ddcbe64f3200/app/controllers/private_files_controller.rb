# Загрузка и скачивание приватных файлов
# @see app/assets/javascripts/profile.js.coffee
# @see etc.

class PrivateFilesController < ApplicationController

  def create
    uploader = PrivateFileUploader.new
    uploader.cache! params[:file]
    render json: { filename: uploader.filename,
                   extension: uploader.file.extension.upcase,
                   cache: uploader.cache_name }
  rescue => ex
    render json: { error: upload_error(ex) }
  end
end
