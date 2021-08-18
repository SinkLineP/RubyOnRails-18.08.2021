class FeedbackQuestionsController < ApplicationController
  before_action :authenticate_user!

  def new
    @feedback_question = params[:course_id].present? ? StudyQuestion.new(course_id: params[:course_id], lecture_id: params[:lecture_id]) : FeedbackQuestion.new(lecture_id: params[:lecture_id])
    @feedback_question.student = current_user
    @feedback_question.set_defaults
  end

  def create
    @feedback_question = current_user.feedback_questions.new(feedback_question_params)

    unless @feedback_question.save
      render 'feedback_questions/new'
      return
    end

    @feedback_question.send_mail
    back_url = @feedback_question.course_id.present? ? course_path(@feedback_question.course_id) : feedback_message_sent_path
    redirect_to back_url
  end

  private

  def feedback_question_params
    params.require(:feedback_question).permit(:type,
                                              :text,
                                              :instructor_id,
                                              :file_cache,
                                              :course_id,
                                              :student_name,
                                              :groups,
                                              :phone,
                                              :work_title,
                                              :absent_dates,
                                              :new_dates,
                                              :working_off_type)
  end
end