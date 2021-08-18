class LecturesController < ApplicationController
  include UserActivityRecordable
  include RedirectForCourses

  load_resource :course

  before_action do
    @lecture = @course.lectures.find(params[:id])
    authorize! :show, @lecture, course: @course
  end

  before_action :dashboard_mode

  def show
    @personal_notice = PersonalNotice.unread.find_by(lecture_id: @lecture.id, student_id: current_user.id)
    @personal_notice.update_column(:read, true) if @personal_notice.present?

    @block = @lecture.block
    record_activity
    set_meta
    render 'courses/show'
  end

  protected

  def set_meta
    set_meta_tags title: @lecture.description, og: {title: @lecture.description,
                                                    type: 'article',
                                                    url: course_lecture_url(@course, @lecture)}
  end
end