# frozen_string_literal: true

# Контроллер раздела "Преподаватели"
# @see app/views/admin/instructors
module Admin
  class InstructorsController < AdminController
    before_action only: %i[edit update destroy change_password] do
      @instructor = Instructor.find(params[:id])
      @instructor.build_instructor_home if @instructor.instructor_home.blank?
      force_update_current_shop_id(@instructor.shop_id)
    end

    authorize_resource

    set_current_shop_for_model(Instructor)
    set_current_shop_for_model(Faculty)
    set_current_shop_for_model(Course)
    set_current_shop_for_model(Group)

    before_action only: %i[new create] do
      @instructor = Instructor.new
      @instructor.build_instructor_home
    end

    def index
      @instructors = Instructor.ordered.paginate(page: params[:page], per_page: params[:per_page])
    end

    def new
      @groups = Group.for_instructor(@instructor).ordered
    end

    def create
      @instructor.assign_attributes(instructor_params)
      @instructor.source = :dashboard
      save_and_response
    end

    def edit
      @groups = Group.for_instructor(@instructor).ordered
    end

    def update
      instructor_params.delete(:password) if instructor_params[:password].blank?
      @instructor.assign_attributes(instructor_params)
      save_and_response
    end

    def destroy
      @instructor.destroy
      redirect_to admin_instructors_path
    end

    def change_password
      @instructor.assign_attributes(password: params[:password])
      save_and_response(send_password: true)
    end

    def list
      instructors = Instructor.alphabetical_order

      if params[:term].present?
        instructors = instructors.where('last_name ilike :term OR first_name ilike :term OR middle_name ilike :term', term: "%#{params[:term]}%")
      end

      render json: instructors.first(LIST_SIZE).map { |instructor| { value: instructor.full_name, id: instructor.id } }
    end

    protected

    def save_and_response(options = {})
      send_password = options.fetch(:send_password, false)
      if @instructor.save
        CosmetologyMailer.instructor_password_changed(@instructor).deliver if send_password
        @alert = 'Пароль был успешно изменён и выслан преподавателю.'
        redirect_to edit_admin_instructor_path(@instructor)
      else
        @groups = Group.for_instructor(@instructor).ordered
        render :edit
      end
    end

    def instructor_params
      @instructor_params ||= load_instructor_params
    end

    def load_instructor_params
      result = params.require(:user).permit(
        :first_name,
        :middle_name,
        :description,
        :last_name,
        :email,
        :password,
        :email_password,
        :avatar_cache,
        faculty_ids: [],
        linked_course_ids: [],
        instructor_works_attributes: %i[id work_id _destroy],
        instructor_home_attributes: %i[id active description rows_count]
      ).tap do |h|
        %i[faculty_ids linked_course_ids].each do |name|
          h[name] ||= []
        end
      end
      result.merge!(group_ids: params['group_ids'].reject(&:blank?).uniq) if params['group_ids'].present?
      result
    end
  end
end
