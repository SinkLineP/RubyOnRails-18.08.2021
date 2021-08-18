# Договор для сделки
# @see app/views/admin/subscription_contracts
# @see app/views/admin/group_subscriptions
module Admin
  class SubscriptionContractsController < AdminController
    load_and_authorize_resource :group_subscription

    def show
      load_documents
    end

    def update
      @group_subscription.assign_attributes(group_subscription_params)
      if @group_subscription.valid?
        @group_subscription.save_and_generate_documents!
        redirect_to admin_group_subscription_contract_path(@group_subscription)
        return
      end
      load_documents
      render :show
    end

    def send_contract
      documents = [
        @group_subscription.subscription_contract,
        @group_subscription.practice_agreement
      ]
      CosmetologyMailer.send_student_contract(@group_subscription.student, @group_subscription.subscription_contract, documents).deliver
      redirect_to admin_group_subscription_contract_path(@group_subscription)
    end

    protected

    def group_subscription_params
      params.require(:group_subscription).permit!
    end

    private

    def load_documents
      @practice_agreement = @group_subscription.practice_agreement || @group_subscription.build_practice_agreement
      @payer_agreement = @group_subscription.payer_agreement
      @questionnaire = @group_subscription.questionnaire || @group_subscription.build_questionnaire
      @vacation_order = @group_subscription.vacation_order || @group_subscription.build_vacation_order
      @subscription_contract = @group_subscription.subscription_contract || @group_subscription.build_subscription_contract(created_on: Date.today)
    end
  end
end