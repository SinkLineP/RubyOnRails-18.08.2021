class TaskFilesController < ApplicationController
  before_action do
    @course = Course.find(params[:course_id])
    @task = Task.find(params[:task_id])
    authorize! :pass, @task, course: @course
  end

  def create
    file = FileUploader.new
    file.cache!(params[:files].first)
    render json: {fileCache: file.cache_name, fileName: file.filename}
  rescue => ex
    render json: {error: ex.message}
  end
end