# Загрузка изображения для вопроса теста
# @see app/assets/javascripts/admin/blocks/views/tasks/test/question.coffee
module Admin
  class QuestionImagesController < AdminController
    def create
      uploader = QuestionImageUploader.new
      uploader.cache! params[:file]
      render json: { filename: uploader.filename, cache: uploader.cache_name }
    rescue Exception => e
      render json: { error: upload_error(e) }
    end
  end
end