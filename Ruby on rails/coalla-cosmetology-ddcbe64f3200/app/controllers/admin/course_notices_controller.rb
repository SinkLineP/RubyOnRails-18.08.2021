# Контроллер рассылки по курсам
# @see app/views/admin/course_notices
# @see app/views/admin/courses/_course.html.haml
# @see app/views/admin/groups/_group.html.haml
module Admin
  class CourseNoticesController < AdminController
    load_and_authorize_resource :course, if: 'params[:group_id].blank?'
    before_action if: 'params[:group_id].present?' do
      @group = Group.find(params[:group_id])
      @course = @group.course
    end
    authorize_resource :group, if: 'params[:group_id].present?'

    before_action do
      @notice = Notice.new
    end

    def new
      @notice.notice_groups.build(group: @group) if @group
    end

    def create
      @notice.assign_attributes(params.require(:notice).permit!)

      if @notice.save
        @notice.notify_students
        redirect_to @group ? admin_groups_path : admin_courses_path
      else
        render :new
      end
    end
  end
end