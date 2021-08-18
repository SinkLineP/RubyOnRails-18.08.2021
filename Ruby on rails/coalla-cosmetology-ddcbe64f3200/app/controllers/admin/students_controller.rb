# frozen_string_literal: true

# Контроллер раздела "Студенты"
# @see app/views/admin/students
module Admin
  class StudentsController < AdminController
    include LoggerableMethods

    authorize_resource

    before_action :store_path_history

    before_action except: :index do
      @courses = Course.ordered
    end

    before_action only: [:edit, :update, :destroy] do
      @student = Student.find(params[:id])
    end

    def index
      @sort_types = [["По имени ↑", "users.last_name"],
                     ["По имени ↓", "users.last_name DESC"],
                     ["По дате создания ↑", "users.created_at"],
                     ["По дате создания ↓", "users.created_at DESC"]]
      @sort_type = @sort_types.flat_map(&:second).detect { |s| s.eql?(params[:sort_type]) } || "users.last_name"
      scope = Student.order(@sort_type)
      if params[:q].present?
        @search_text = params[:q].delete(:id_cont)
        scope = scope.joins(:user_phones).where("(users.email ILIKE :text
                              OR array_to_string(users.emails, '||') ILIKE :text
                              OR user_phones.number ILIKE :text
                              OR concat(users.last_name, ' ', users.first_name, ' ', users.middle_name) ILIKE :text)", text: "%#{@search_text}%") if @search_text.present?
      end
      @q = scope.ransack(prepare_ransack_params(params[:q]))
      @students = @q.result.uniq.paginate(page: params[:page], per_page: params[:per_page])
      if @q.groups_id_eq.present?
        @q.course_id_eq = Group.find_by(id: @q.groups_id_eq).try(:course_id)
      end
      @groups = (@q.course_id_eq.present? ? Group.where(course_id: @q.course_id_eq) : Group).active.ascending_name
      @last_import = AmocrmImport.last
      params[:q][:id_cont] = @search_text if @search_text.present?
    end

    def new
      @student = Student.new
      @user_phones = @student.user_phones.new
    end

    def create
      @student = Student.new(student_params)
      @student.password = Devise.friendly_token(8)
      @student.source = :dashboard
      if @student.save
        logger_create(@student, current_user,
                      "Пользователь (id: #{@student.id}): " + student_link(@student))
        Mindbox::XmlApiOperation.enqueue("FirstEmail",
                                         email: @student.email,
                                         password: @student.password)
        render json: { redirect_url: edit_admin_student_path(@student) }
      else
        render json: { errors: @student.errors.full_messages.join("\n") }
      end
    end

    def edit
      user_phones = @student.user_phones.new unless @student.user_phones.present?
    end

    def update
      student_params.delete(:group_subscriptions_attributes) unless @student.student?
      @student.assign_attributes(student_params)
      changed = @student.changed_attributes.keys
      if @student.save
        logger_updated(@student, current_user,
                      "Пользователь (id: #{@student.id}): " +
                      student_link(@student).to_s,
                      changed)
        render json: { redirect_url: edit_admin_student_path(@student) }
      else
        render json: { errors: @student.errors.full_messages.join("\n") }
      end
    end

    def import
      service = ImportService.new
      document = Document.new(file: params[:file])
      service.run(document.file.path)
      render json: { errors: render_to_string(:import, locals: { messages: service.full_messages.join("<br>") }, layout: false) }
    end

    def destroy
      logger_delete(@student, current_user,
                    "Пользователь (id: #{@student.id}): " + student_link(@student))
      @student.erase!
      redirect_to last_uri
    end

    def list
      students = Student.by_alphabet
      students = students.where("concat_ws(' ', id, amocrm_id, email, last_name, first_name, middle_name, array_to_string(emails, ' ')) ilike ?", "%#{params[:term]}%") if params[:term].present?
      students_json = students.first(20).map do |student|
        { id: student.id,
          value: student.full_name_with_ids,
          html: render_to_string(partial: "admin/contacts_merges/student", locals: { student: student })
        }
      end
      render json: students_json
    end

    protected

    def student_params
      @student_param ||= params.require(:user).permit(:first_name,
                                                      :last_name,
                                                      :middle_name,
                                                      :birthday,
                                                      :translit_name,
                                                      :education_level_id,
                                                      :email,
                                                      :demo,
                                                      :emails_string,
                                                      :passport_series,
                                                      :passport_number,
                                                      :passport_issued_on,
                                                      :passport_organisation,
                                                      :passport_address,
                                                      :address,
                                                      :amocrm_id,
                                                      :wear_size,
                                                      document_copies_attributes: [:id, :_destroy, :file_cache],
                                                      student_documents_attributes: [:id, :_destroy, :document_type, :file_cache, :title],
                                                      group_subscriptions_attributes: [:id, :group_id, :begin_on, :end_on],
                                                      comment_threads_attributes: [:id, :_destroy, :body, :creator_id, :creator_type],
                                                      user_phones_attributes: [:id, :number, :_destroy])
    end
  end
end
