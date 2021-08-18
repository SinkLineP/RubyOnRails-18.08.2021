# Выбор занятий курса
# app/views/admin/courses/_form.html.haml
module Admin
  class CourseWorksController < AdminController
    load_and_authorize_resource :group
    before_action do
      @course = @group.course
    end

    def index
      render json: @course.works.order_by_title.as_json(only: [:id, :title])
    end
  end
end