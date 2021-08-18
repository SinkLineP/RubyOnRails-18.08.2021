# Загрузка и скачивание приватных файлов
# @see app/assets/javascripts/profile.js.coffee
# @see app/assets/javascripts/project.js
# @see app/assets/javascripts/admin/edit_user_from.js.coffee
# @see etc.
module Admin
  class PrivateFilesController < AdminController
    def show
      file = File.open(File.join(PrivateFileUploader.root, URI.decode(params[:file])))
      send_file file
    end

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
end