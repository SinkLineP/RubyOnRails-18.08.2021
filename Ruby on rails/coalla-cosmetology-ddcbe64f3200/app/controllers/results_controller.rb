class ResultsController < ApplicationController
  include RedirectForCourses

  before_action except: :show do
    @task = Task.find(params[:task_id])
    @lecture = @task.lecture
  end

  before_action do
    @course = Course.find(params[:course_id])
  end

  before_action only: :show do
    @result = Result.find(params[:id])
  end

  before_action only: [:create, :expire] do
    @user_activity = UserActivity.find(params[:activity_id])
  end

  before_action only: [:create, :expire] do
    authorize! :pass, @task, course: @course
  end

  before_action only: :show do
    authorize! :show, @result, course: @course
  end

  def create
    @result = @task.new_result_model(user: current_user)
    @result.assign_attributes(result_params)

    if @result.mark_result
      update_activity!
      redirect_to course_result_path(params[:course_id], @result)
    else
      render 'tasks/show'
    end
  end

  def show
    @task = @result.task
    @lecture = @task.lecture
  end

  def expire
    @result = @task.new_result_model(user: current_user)
    @result.assign_attributes(result_params)
    @result.expire!
    update_activity!
    render json: {redirectUrl: course_result_path(params[:course_id], @result)}
  end

  private

  def result_params
    return {} if params[:result].blank?
    params.require(:result).permit(:answer, result_file_items_attributes: [:file_cache], result_test_items_attributes: [:question_id, :question_answer_id], result_connection_items_attributes: [:column_id, :column_variant_id])
  end

  def update_activity!
    @user_activity.with_lock do
      created_at = @user_activity.created_at
      @user_activity.update!(trackable: @result, description: @result.description_for_activity, last_tracked_at: Time.now, spent_time: Time.now - created_at)
    end
  end
end