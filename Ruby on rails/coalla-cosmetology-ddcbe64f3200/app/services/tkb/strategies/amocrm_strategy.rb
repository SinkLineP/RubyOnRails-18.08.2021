# frozen_string_literal: true

module Tkb
  module Strategies
    class AmocrmStrategy < BaseStrategy
      protected

      def load_data
        @group_subscription = GroupSubscription.find_by!(amocrm_id: @params[:orderid])
        true
      end

      def receipt_params
        { item: @group_subscription }
      end

      def apply_payment!
        log = PaymentLog.create!(payment_type: :site,
                                 payed_on: Date.current,
                                 appointment: :education,
                                 group_id: @group_subscription.group_id,
                                 amount: @params[:sum].to_f,
                                 student_id: @group_subscription.student_id)
        logger.info("Payment Log (id=#{log.id}) for Subscription(id=#{log.id}) created.")
      end
    end
  end
end
