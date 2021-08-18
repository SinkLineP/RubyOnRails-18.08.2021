# Контроллер раздела "Курсы"
# @see app/views/admin/courses/
module Admin
  class CoursesController < AdminController
    POSITION = CourseSeo::POSITION
    before_action only: [:edit, :update, :destroy] do
      @course = Course.includes(:course_seos).find(params[:id])
      create_seo_blocks(@course) if @course.course_seos.empty?
      force_update_current_shop_id(@course.shop_id)
    end

    with_options except: :list do
      set_current_shop_for_model(Course)
      set_current_shop_for_model(Block)
      set_current_shop_for_model(Faculty)
    end

    authorize_resource

    before_action only: [:new, :create] do
      @course = Course.new(course_params)
    end

    def index
      @q = Course.ransack(params[:q])
      @courses = @q.result.ordered.paginate(page: params[:page] || 1, per_page: PER_PAGE)
    end

    def new; end

    def create
      apply_commit_action
    end

    def edit; end

    def update
      assign_seo_content @course
      @course.assign_attributes(course_params)
      apply_commit_action
    end

    def destroy
      @course.destroy!
      redirect_to url_for(action: :index)
    end

    def list
      set_current_shop_for_model(Course) if params[:shop]
      courses = Course.alphabetical_order
      courses = courses.where('name ilike ?', "%#{params[:term]}%") if params[:term].present?
      render json: courses.first(LIST_SIZE).map { |course| { value: course.name, id: course.id, link: edit_admin_course_path(course) } }
    end

    protected

    def preview
      @block = @course.blocks.first
      @lecture = @block.try(:lectures).try(:first)
      dashboard_mode
      render 'courses/show', layout: 'user', locals: { preview: true }
    end

    def save
      if @course.save
        redirect_to edit_admin_course_path(@course)
      else
        render :edit
      end
    end

    def create_seo_blocks(course)
      course.course_seos.create([{ place: POSITION[0]}, {place: POSITION[1]}, {place: POSITION[2]}])
    end

    def assign_seo_content(course)
      course.course_seos.block1.take.update_attribute(:content, course_params["course_seos_attributes"]["0"]["content"])
      course.course_seos.header2.take.update_attribute(:content, course_params["course_seos_attributes"]["1"]["content"])
      course.course_seos.block2.take.update_attribute(:content, course_params["course_seos_attributes"]["2"]["content"])
    end

    def course_params
      params.require(:course).permit(:name,
                                     :price,
                                     :remote_price,
                                     :cost,
                                     :short_name,
                                     :hours,
                                     :faculty_id,
                                     :external_url,
                                     :diplom_title,
                                     :active,
                                     :syllabus,
                                     :syllabus_cache,
                                     :timetable,
                                     :appointment,
                                     :course_counts,
                                     :notification_audio,
                                     :additional_amo_module_id,
                                     :with_amo_module,
                                     :place_over_notification,
                                     :ivr_audio,
                                     :status_notification_name,
                                     :student_docs_required,
                                     course_documents_attributes: [:id,
                                                                   :education_document_id,
                                                                   :education_level_id,
                                                                   :academic_hours,
                                                                   :program_name,
                                                                   :diploma_title,
                                                                   :_destroy],
                                     course_works_attributes: [:id,
                                                               :work_id,
                                                               :lecture_id,
                                                               :main,
                                                               :hours,
                                                               :practice,
                                                               :_destroy],
                                     course_seos_attributes: [:id,
                                                              :course_id, 
                                                              :place,
                                                              :content,
                                                              :_destroy],
                                     block_ids: [],
                                     speciality_ids: [])
    rescue
      {}
    end

  end

end
