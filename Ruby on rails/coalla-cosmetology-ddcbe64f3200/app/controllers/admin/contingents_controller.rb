# Отчет "Контингент"
# @see app/views/admin/contingents
# @see app/views/admin/students/index.html.haml
module Admin
  class ContingentsController < AdminController
    layout false
    authorize_resource class: false

    def new; end

    def create
      @practice_at = params[:practice_at].presence
      @begin_at = params[:begin_at].presence
      @end_at = params[:end_at].presence

      scope = GroupSubscription
                  .preload(:student,
                           :amo_module,
                           :amocrm_status,
                           :group,
                           :education_form,
                           :subscription_documents,
                           subscription_documents: [:education_document],
                           student: [:education_level],
                           group: [:practices, :course, :addition_order, :expelled_students, expelled_students: :expulsion_order])
                  .joins(:student, :amocrm_status, :course)
                  .includes(group: :practices)
                  .actual
                  .order('users.last_name asc, users.first_name asc, users.middle_name asc')
                  .references(:practices)
      scope = scope.where('? BETWEEN practices.begin_on AND practices.end_on', Date.parse(@practice_at) ) if @practice_at
      scope = scope.where('group_subscriptions.begin_on >= ?', Date.parse(@begin_at)) if @begin_at
      scope = scope.where('group_subscriptions.begin_on <= ?', Date.parse(@end_at)) if @end_at
      @contingents = scope.to_a.uniq

      scope = Group.includes(:practices).references(:practices).distinct.order(:begin_on)
      scope = scope.where('? BETWEEN practices.begin_on and practices.end_on', Date.parse(@practice_at)) if @practice_at
      scope = scope.where('groups.begin_on >= ?', Date.parse(@begin_at)) if @begin_at
      scope = scope.where('groups.begin_on <= ?', Date.parse(@end_at)) if @end_at
      @groups = scope
    end
  end
end