# frozen_string_literal: true

module Documents
  module Generators
    module SubscriptionContractBuilders
      class GovernmentContract
        include DocBuilder
        include DocumentsHelper
        include ActionView::Helpers::NumberHelper

        def initialize(options = {})
          @group_subscription = options[:item]
          @number = options[:number]
          @date = options[:date]
        end

        def build_data
          {
            passport_serie: @group_subscription.student_passport_series,
            passport_number: @group_subscription.student_passport_number,
            passport_issued: passport_issued,
            address: @group_subscription.student_passport_address,
            phone: @group_subscription.student_phones_string,
            email: @group_subscription.student_email,
            payment_type: payment_type(@group_subscription),
            schedule: Common::ScheduleInfo.new(@group_subscription).text
          }
        end

        def passport_issued
          format_date_with_quotes(@group_subscription.student_passport_issued_on).to_s +
            "\n" +
            @group_subscription.student_passport_organisation.to_s
        end
      end
    end
  end
end
