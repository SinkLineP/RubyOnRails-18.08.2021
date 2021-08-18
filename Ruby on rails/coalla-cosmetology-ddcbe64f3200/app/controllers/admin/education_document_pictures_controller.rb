# Загрузка сканов выпускных документов
# @see app/assets/javascripts/admin/education_document_form.js.coffee
module Admin
  class EducationDocumentPicturesController < AdminController
    def create
      uploader = EducationDocumentImageUploader.new
      uploader.cache! params[:file]
      render json: {filename: uploader.filename,
                    extension: uploader.file.extension.upcase,
                    cache: uploader.cache_name}
    rescue => ex
      render json: {error: upload_error(ex)}
    end
  end
end