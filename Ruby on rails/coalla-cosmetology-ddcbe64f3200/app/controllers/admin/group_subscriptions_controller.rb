# Управление сделками студента
# @see app/views/admin/group_subscriptions
# @see app/views/admin/students/_form.html.haml
# @see app/views/admin/students/_student.html.haml
module Admin
  class GroupSubscriptionsController < AdminController
    before_action do
      @student = Student.find(params[:student_id])
    end

    load_and_authorize_resource :group_subscription, through: :student

    helper_method :group_prices

    def index
      @group_subscriptions = @student.group_subscriptions.ordered.paginate(page: params[:page] || 1, per_page: PER_PAGE)
    end

    def new
      @group_subscription = @student.group_subscriptions.new(group: Group.ordered_by_course_name.first,
                                                             education_form: EducationForm.ordered.first,
                                                             practice_entrance_agree_at: Time.current,
                                                             practice_entrance_disagree_at: Time.current,
                                                             practice_date_at: Time.current,
                                                             amo_module_at: Time.current
      )
    end

    def create
      @group_subscription = @student.group_subscriptions.new
      save_and_responce(:create)
    end

    def edit
    end

    def update
      save_and_responce(:update)
    end

    def destroy
      GroupSubscriptions::AmoLeadActionJob.enqueue(:destroy, amocrm_id: @group_subscription.amocrm_id) if @group_subscription.created_by_user?
      @group_subscription.destroy!
      redirect_to admin_student_group_subscriptions_path(@student)
    end

    def really_destroy
      @student.transaction do
        @student.group_subscriptions.only_deleted.each { |s| s.destroy_without_paranoia }
      end
      redirect_to admin_student_group_subscriptions_path(@student)
    end

    def list
      subscriptions = @student.group_subscriptions.ordered.joins(:group).where('groups.title ilike ?', "%#{params[:term]}%") if params[:term].present?
      render json: subscriptions.first(LIST_SIZE).map { |subscription| {
        value: "#{subscription.group.title} (#{subscription.group.begin_on}-#{subscription.group.end_on})",
        id: subscription.id }
      }
    end

    private

    def save_and_responce(action)
      @group_subscription.assign_attributes(group_subscription_params)

      if @group_subscription.valid?
        notify = @group_subscription.status_changed_to_success?
        @group_subscription.save_and_generate_subscription_documents!
        @group_subscription.save_and_generate_documents!
        GroupSubscriptions::Notifier.new(@group_subscription).notify! if notify
        GroupSubscriptions::AmoLeadActionJob.enqueue(action, subscription_id: @group_subscription.id) if @group_subscription.created_by_user?
        redirect_to edit_admin_student_group_subscription_path(@student, @group_subscription)
        return
      end

      render :edit
    end

    def group_subscription_params
      params.require(:group_subscription).permit!
    end

    def group_prices
      @group_prices ||= GroupPrice.where(group: @group_subscription.group,
                                         education_form: @group_subscription.education_form).ordered
    end
  end
end