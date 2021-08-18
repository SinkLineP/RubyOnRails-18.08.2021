module Documents
  module Generators
    class PracticeAgreement
      include DocBuilder
      include DocumentsHelper
      include ActionView::Helpers::NumberHelper

      def initialize(options={})
        @group_subscription = options[:item]
        @number = options[:number]
      end

      def generate
        build_doc('practice_agreement', data)
      end

      private

      def data
        {
            number: @number,
            date: format_date_with_quotes(@group_subscription.practice_agreement_signed_on),
            contract_number: @group_subscription.subscription_contract_number,
            contract_date: format_date_with_quotes(@group_subscription.subscription_contract_created_on),
            course: @group_subscription.course_name,
            student: @group_subscription.student_full_name,
            practice_basis: @group_subscription.practice_basis_title,
            inn: @group_subscription.practice_basis_inn,
            kpp: @group_subscription.practice_basis_kpp,
            address: @group_subscription.practice_basis_address,
            account: @group_subscription.practice_basis_account,
            bik: @group_subscription.practice_basis_bik,
            bank: @group_subscription.practice_basis_bank,
            correspondent_account: @group_subscription.practice_basis_correspondent_account,
            phone: @group_subscription.practice_basis_phone,
            email: @group_subscription.practice_basis_email
        }
      end
    end
  end
end