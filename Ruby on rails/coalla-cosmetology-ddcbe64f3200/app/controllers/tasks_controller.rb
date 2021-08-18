class TasksController < ApplicationController
  include RedirectForCourses

  before_action do
    @course = Course.find(params[:course_id])
    @task = Task.find(params[:id])
    authorize! :pass, @task, course: @course
  end

  def show
    @lecture = @task.lecture
    @previous_result = current_user.result_for_lecture(@lecture)
    @result = @task.new_result_model(user: current_user)
    @result.try(:prepare)
    @user_activity = UserActivity.create!(title: "Задание #{@task.lecture.lecture_index}", description: @result.description_for_activity, last_tracked_at: Time.now, student: current_user)
    gon.activity = @user_activity.as_json
  end
end