# Загрузка файлов для рассылки по курсам
# @see app/assets/javascripts/admin/notice_form.js.coffee
# @see app/views/admin/course_notices/new.haml
module Admin
  class FilesController < AdminController
    def create
      uploader = FileUploader.new
      uploader.cache! params[:file]
      render json: { filename: uploader.filename,
                     extension: uploader.file.extension.upcase,
                     cache: uploader.cache_name }
    rescue => ex
      render json: { error: upload_error(ex) }
    end
  end
end