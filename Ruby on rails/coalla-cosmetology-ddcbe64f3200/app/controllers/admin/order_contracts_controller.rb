# Договор для заказа
# @see app/views/admin/order_contracts/show.haml
# @see app/views/admin/orders/show.haml
module Admin
  class OrderContractsController < AdminController
    load_and_authorize_resource :order

    def show
      redirect_to admin_student_order_path(@order) unless @order.order_subscription?
      @student = @order.user
      @group_subscription = group_subscription
      @payer_agreement = group_subscription.payer_agreement
      @order_contract = @order.order_contract || @order.build_order_contract(created_on: Date.today)
      @questionnaire = group_subscription.questionnaire || group_subscription.build_questionnaire
      @vacation_order = group_subscription.vacation_order || group_subscription.build_vacation_order
    end

    def update
      order_contract_save!
      group_subscription_save!
      @order.generate_documents!
      redirect_to admin_order_contract_path(@order)
    end

    def send_contract
      CosmetologyMailer.send_student_order_contract(@order, @order.user, @order.order_contract).deliver!
      redirect_to admin_order_contract_path(@order)
    end

    protected

    def order_contract_save!
      order_contract = @order.order_contract || @order.build_order_contract(created_on: Date.today)
      order_contract.assign_attributes(order_contract_params)
      order_contract.save!
    end

    def group_subscription_save!
      group_subscription.update_attributes(group_subscription_params)
      group_subscription.save!
    end

    def group_subscription_params
      params.require(:group_subscription).except(:order_contract_attributes).permit!
    end

    def order_contract_params
      params.require(:group_subscription).require(:order_contract_attributes).permit!
    end

    def group_subscription
      @order.first_subscription
    end
  end
end