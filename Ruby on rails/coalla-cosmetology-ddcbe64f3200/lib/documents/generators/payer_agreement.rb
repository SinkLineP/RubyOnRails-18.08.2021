module Documents
  module Generators
    class PayerAgreement
      include DocBuilder
      include DocumentsHelper
      include ActionView::Helpers::NumberHelper

      def initialize(options={})
        @group_subscription = options[:item]
        @number = options[:number]
      end

      def generate
        build_doc('payer_agreement', data)
      end

      private

      def data
        {
            number: @number,
            date: format_date_with_quotes(@group_subscription.payer_agreement_signed_on),
            contract_number: @group_subscription.subscription_contract_number,
            contract_date: format_date_with_quotes(@group_subscription.subscription_contract_created_on),
            student: @group_subscription.student_full_name,
            payer: @group_subscription.payment_requisite_name,
            inn: @group_subscription.payment_requisite_inn,
            kpp: @group_subscription.payment_requisite_kpp,
            address: @group_subscription.payment_requisite_address,
            account: @group_subscription.payment_requisite_account,
            bik: @group_subscription.payment_requisite_bik,
            bank: @group_subscription.payment_requisite_bank,
            correspondent_account: @group_subscription.payment_requisite_correspondent_account,
            phone: @group_subscription.payment_requisite_phone,
            email: @group_subscription.payment_requisite_email
        }
      end
    end
  end
end