# Генерация документов об образовании
# @see app/views/admin/group_subscriptions
# @see app/assets/javascripts/admin/group_subscriptions.js.coffee
module Admin
  class SubscriptionDocumentsController < AdminController
    load_and_authorize_resource :student

    def generate
      if params[:group_id].blank?
        render json: {}
        return
      end

      @group = Group.find(params[:group_id])
      @amo_module = AmoModule.find_by(id: params[:amo_module_id])
      @group_subscription = GroupSubscription.new(student: @student,
                                                  group: @group,
                                                  amo_module: @amo_module)
      @group_subscription.generate_subscription_documents

      render json: {
        html: render_to_string(partial: 'admin/group_subscriptions/subscription_documents')
      }
    end
  end
end