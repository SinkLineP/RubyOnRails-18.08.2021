module CoursesShop
  class UserCoursesController < BaseController

    before_action :authenticate_user!

    def show
      @filter_options = %w(active pending archive payment_not_completed)
      @current_option = params[:filter].presence_in(@filter_options) || @filter_options.first
      group_subscriptions = current_user.group_subscriptions
      pending_subscriptions = group_subscriptions.actual
                                                 .not_expelled
                                                 .select { |gs| !%w(full_paid archive).include?(gs.paid_status) }
      @group_subscriptions = {
        'active' => (group_subscriptions.active.ordered.select { |gs| gs.paid_status == 'full_paid' } + pending_subscriptions).uniq,
        'archive' => group_subscriptions.actual.expired.not_expelled.not_academic_vacation.select(&:archived?),
        'pending' => pending_subscriptions,
        'payment_not_completed' => group_subscriptions.payment_not_completed
      }[@current_option]
    end

    def download_document
      scope = params[:by_order_scope] ? current_user.orders_generated_documents : current_user.generated_documents
      @generated_document = scope.find(params[:id])
      send_file @generated_document.path
    end

  end

end