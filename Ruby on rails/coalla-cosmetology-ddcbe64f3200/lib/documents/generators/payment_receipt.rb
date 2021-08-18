module Documents
  module Generators
    class PaymentReceipt
      include DocBuilder
      include DocumentsHelper
      include ActionView::Helpers::NumberHelper

      def initialize(options={})
        @order = options[:item]
      end

      def generate
        build_doc('payment_receipt', data)
      end

      private

      def data
        {
            student_name: @order.user.full_name,
            payment: @order.full_price_with_discount.to_i
        }
      end
    end
  end
end