# Контроллер раздела "Мои студенты"
# @see app/views/admin/my_students
# @see app/views/admin/students/_form.html.haml
# @see app/views/admin/students/_student.html.haml
module Admin
  class MyStudentsController < AdminController
    authorize_resource :student

    def index
      @sort_types = [['По имени ↑', 'users.last_name'],
                     ['По имени ↓', 'users.last_name DESC'],
                     ['По дате создания ↑', 'users.created_at'],
                     ['По дате создания ↓', 'users.created_at DESC']]
      @sort_type = @sort_types.flat_map(&:second).detect { |s| s.eql?(params[:sort_type]) } || 'users.last_name'

      condition = params[:ghost] == 'true' ? :students : :active_students
      @q = current_user.send(condition).order(@sort_type).ransack(params[:q])
      @students = @q.result.joins(:group_subscriptions)
                    .references(:group_subscriptions)
                    .distinct.paginate(page: params[:page],
                                       per_page: params[:per_page])
      if @q.groups_id_eq.present?
        @q.course_id_eq = Group.find_by(id: @q.groups_id_eq).try(:course_id)
      end
      group_scope = current_user.instructor? ? current_user.groups : Group
      @groups = (@q.course_id_eq.present? ? group_scope.where(course_id: @q.course_id_eq) : group_scope).active.ascending_name
      @tasks_ids = current_user.tasks if current_user.instructor?
    end

    def show
      load_items

      @grouped_file_results = @student.results.includes(task: :lecture).where(tasks: { lecture_id: @course.lectures.map(&:id) }).select(&:file?).group_by(&:task)
      @on_mark_results = @student.on_mark_results(@course)
      @marked_results = @student.marked_results(@course)

      prepare_graph_data
    end

    LIMIT = 10

    def list
      students = current_user.students.where('group_subscriptions.end_on >= ?', Date.today).order(:last_name).distinct
      students = students.where('title ilike ?', "#{params[:term]}%") if params[:term].present?

      render json: students.first(LIMIT).map { |student| { label: student.name_with_email, value: student.email } }
    end

    def report
      load_items

      xls = render_to_string('report', layout: false)
      send_data(xls, type: 'application/xls', filename: "student_activity_id_#{@student.id}_course_#{@course.id}.xls")
    end

    private

    def prepare_graph_data
      builder = GraphDataBuilder.new(@course_activities.reverse)
      @activity_graph_data = builder.activity_graph_data
      @results_graph_data = builder.results_graph_data
    end

    def load_items
      if current_user.instructor?
        @student = current_user.students.find(params[:id])
        @group_subscriptions = @student.group_subscriptions_for_instructor(current_user)
      else
        @student = Student.find(params[:id])
        @group_subscriptions = @student.group_subscriptions.with_deleted
      end

      @group_subscription =
        if params[:subscription].present?
          @group_subscriptions.find(params[:subscription])
        else
          @group_subscriptions.first
        end

      @course = @group_subscription.group.course

      @course_activities = @student.user_activities_for_course(@course, @group_subscription.created_at, @group_subscription.to)
    end
  end
end