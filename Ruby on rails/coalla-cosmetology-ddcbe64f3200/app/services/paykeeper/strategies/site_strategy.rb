module Paykeeper
  module Strategies
    class SiteStrategy < BaseStrategy
      protected

      def load_data
        @order = Order.find(@params[:orderid])
        logger.info("Order params: #{@order.payment_params}")
        true
      end

      def receipt_params
        { item: @order }
      end

      def correct_data?
        super && correct_order_params?
      end

      def correct_order_params?
        @params[:sum].to_i == @order.payment_params[:sum] && @params[:clientid] == @order.payment_params[:clientid]
      end

      def apply_payment!
        @order.transaction do
          promo_code = @order.promo_code
          promo_code.update_columns(extinguished: true) if promo_code && !promo_code.reusable?
          @order.current_group_subscriptions.each do |subscription|
            create_subscription_payment!(subscription)
            update_subscription!(subscription) if @order.cart? && !subscription.zero_price_with_installment?
            subscription.update_columns(pending_payment_at: nil)
          end
          @order.update_columns(status: :paid)
        end
        ::GroupSubscriptions::OrderSubscriptionsNotifier.new(@order).notify!
      end

      def create_subscription_payment!(subscription)
        log = PaymentLog.create!(payment_type: :site,
                                 payed_on: Date.current,
                                 appointment: :education,
                                 group_id: subscription.group_id,
                                 amount: subscription.payment_amount(@order),
                                 student_id: @order.user_id,
                                 order_id: @order.id)
        logger.info("Payment Log (id=#{log.id}) for Subscription(id=#{log.id}) created.")
      end

      def update_subscription!(subscription)
        subscription.amocrm_status = AmocrmStatus.success
        subscription.save_and_generate_documents!
        ::GroupSubscriptions::AmoLeadActionJob.enqueue(:update, subscription_id: subscription.id, queue: :amocrm)
        logger.info("Subscription (id=#{subscription.id}) updated.")
      end

    end
  end
end