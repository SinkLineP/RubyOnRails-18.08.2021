# Загрузка изображения для вопроса теста соединения
# @see app/assets/javascripts/admin/blocks/views/tasks/test/question.coffee
module Admin
  class ColumnVariantImagesController < AdminController
    def create
      uploader = ColumnVariantImageUploader.new
      uploader.cache! params[:file]
      render json: { filename: uploader.filename, cache: uploader.cache_name }
    rescue Exception => e
      render json: { error: upload_error(e) }
    end
  end
end