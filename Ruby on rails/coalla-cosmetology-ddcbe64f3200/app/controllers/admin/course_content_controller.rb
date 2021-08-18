# Редактирование контента курса
# @see app/views/admin/course_content/
# @see app/views/admin/courses/_form.html.haml
# @see app/views/admin/courses/_course.html.haml
module Admin
  class CourseContentController < AdminController

    load_and_authorize_resource :course

    before_action only: %i(edit update) do
      force_update_current_shop_id(@course.shop_id)
    end

    set_current_shop_for_model(Course)
    set_current_shop_for_model(Speciality)
    set_current_shop_for_model(Recall)
    set_current_shop_for_model(Instructor)

    def edit; end

    def update
      @course.assign_attributes(course_params)
      if @course.save
        redirect_to edit_admin_course_content_path(@course)
      else
        render :edit
      end
    end

    def course_params
      params.require(:course).permit!.tap do |h|
        %i(subject speciality_ids advantage_ids curriculum_block_ids recall_ids instructor_ids similar_ids skill_ids education_document_ids).each do |name|
          h[name] ||= []
        end
      end
    end

    protected

    def after_shop_update_path
      url_for(controller: :courses, action: :index)
    end
  end
end