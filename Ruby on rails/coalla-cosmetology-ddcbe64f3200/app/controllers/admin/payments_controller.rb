# Рассчет платежей сделки
# @see app/assets/javascripts/admin/group_subscriptions.js.coffee
# @see app/views/admin/group_subscriptions/_form.html.haml
module Admin
  class PaymentsController < AdminController
    load_and_authorize_resource :student

    def recalculate
      data = params[:data]
      if data[:group_id].blank? || data[:group_price_id].blank?
        render json: {}
        return
      end

      @group = Group.find(data[:group_id])

      group_price = @group.prices.find(data[:group_price_id])
      discount = Discount.find(data[:discount_id]) if data[:discount_id].present?

      @group_subscription = data[:group_subscription_id].blank? ? GroupSubscription.new : GroupSubscription.find_by(id: data[:group_subscription_id])
      @group_subscription.assign_attributes(group: @group, group_price: group_price, discount: discount)
      @group_subscription.calculate_payments

      render json: { html: render_to_string(partial: 'admin/group_subscriptions/payments'), price: @group_subscription.price }
    end
  end
end