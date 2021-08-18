class FeedbackQuestionFilesController < ApplicationController
  before_action :authenticate_user!

  def create
    file = FileUploader.new
    file.cache!(params[:file])

    if file.size > FeedbackQuestion::MAX_FILE_SIZE.megabytes
      render json: {error: "Вы не можете загрузить файл, размер которого превышает #{FeedbackQuestion::MAX_FILE_SIZE} МБ"}
    else
      render json: {fileCache: file.cache_name}
    end
  rescue => ex
    render json: {error: ex.message}
  end
end