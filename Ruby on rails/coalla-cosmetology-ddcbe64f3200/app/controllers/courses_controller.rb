class CoursesController < ApplicationController
  include UserActivityRecordable
  include RedirectForCourses

  load_and_authorize_resource

  before_action :dashboard_mode, except: :rating

  def show
    @lecture = current_user.current_lecture_for_course(@course)

    if @lecture.present?
      @personal_notice = PersonalNotice.unread.find_by(lecture_id: @lecture.id, student_id: current_user.id)
      @personal_notice.update_column(:read, true) if @personal_notice.present?
    end

    @block = @lecture.block
    @notices = current_user.notices_for_course(@course)
    record_activity
    set_meta
  end

  def rating
    @subscriptions = GroupSubscription.joins(:course)
                       .actual
                       .not_expelled
                       .not_academic_vacation
                       .not_ended
                       .with_course(@course)
                       .ordered_by_rating_place
  end

  private

  def set_meta
    title = "Курс #{@course.name}"
    set_title(title)
    set_meta_tags og: { title: title,
                        type: 'article',
                        url: course_url(@course) }
  end

end