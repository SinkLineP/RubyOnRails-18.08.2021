module Documents
  module Generators
    module OrderContractBuilders
      class AnotherContract
        include DocBuilder
        include DocumentsHelper
        include ActionView::Helpers::NumberHelper

        def initialize(options)
          @group_subscription = options[:item].first_subscription
          @number = options[:number]
          @date = options[:date]
        end

        def build_data
          {
              company_name: @group_subscription.payment_requisite_name,
              position: @group_subscription.payment_requisite_position,
              position_name: @group_subscription.payment_requisite_position_name,
              legal_address: @group_subscription.payment_requisite_legal_address,
              address: @group_subscription.payment_requisite_address,
              bank: @group_subscription.payment_requisite_bank,
              bik: @group_subscription.payment_requisite_bik,
              inn: @group_subscription.payment_requisite_inn,
              kpp: @group_subscription.payment_requisite_kpp,
              checking_account: @group_subscription.payment_requisite_account,
              cor_account: @group_subscription.payment_requisite_correspondent_account,
              phone: @group_subscription.payment_requisite_phone,
              email: @group_subscription.payment_requisite_email,
              payment_type: payment_type(@group_subscription),
              position_name_genitive: full_name_form(@group_subscription.payment_requisite_position_name),
              position_genitive: @group_subscription.payment_requisite_position_genitive,
              based: @group_subscription.payment_requisite_based.present? ? @group_subscription.payment_requisite_based : 'Устава'
          }
        end
      end
    end
  end
end