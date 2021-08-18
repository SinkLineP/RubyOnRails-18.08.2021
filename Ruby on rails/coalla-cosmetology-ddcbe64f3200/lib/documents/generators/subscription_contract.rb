module Documents
  module Generators
    class SubscriptionContract
      include DocBuilder
      include DocumentsHelper
      include ActionView::Helpers::NumberHelper

      def initialize(options={})
        @group_subscription = options[:item]
        @number = options[:number]
        @date = options[:date]
        @options = options
        @builder_class = if @group_subscription.government?
                           SubscriptionContractBuilders::GovernmentContract
                         elsif @group_subscription.generate_payer_agreement?
                           SubscriptionContractBuilders::AnotherContract
                         else
                           SubscriptionContractBuilders::StudentContract
                         end
      end

      def generate
        build_doc("subscription#{subscription_prefix(@group_subscription)}#{subscription_postfix(@group_subscription)}", data)
      end

      def subscription_prefix(subscription)
        if @date < Time.new(2021, 02, 14, 23, 59, 59) || subscription.government?
          '_contract'
        else
          '_certificate'
        end
      end

      def subscription_postfix(subscription)
        postfix = ''
        if @date < Time.new(2021, 02, 14, 23, 59, 59) || subscription.government?
          postfix = if subscription.generate_payer_agreement?
                      '_another'
                    elsif @group_subscription.government?
                      '_government'
                    else
                      ''
                    end
          if subscription.contract_with_appendix? && !@group_subscription.government?
            postfix += subscription.course_hours.to_i < Course.long_course_hours.to_i ? '_with_appendix' : '_with_appendix_100'
          end
        end
        postfix
      end

      def data
        {
          number: @number,
          date: format_date_with_quotes(@date),
          student: @group_subscription.student_full_name,
          course: @group_subscription.course_name,
          faculty: "факультет #{@group_subscription.faculty_title}",
          hours: "#{@group_subscription.course_hours.to_i} #{Russian.p(@group_subscription.course_hours.to_i, 'академический час', 'академических часа', 'академических часов')}",
          study_dates: "с #{course_start} по #{course_end}",
          schedule: Common::ScheduleInfo.new(@group_subscription).text,
          education_form: @group_subscription.education_form_title,
          documents_list: @group_subscription.documents_list,
          price: format_price_for_contract(@group_subscription.price, false),
          appendix_date: format_date_with_quotes(@group_subscription.appendix_signed_on)
        }
        .merge(certificate_data)
        .merge(@builder_class.new(@options).build_data)
      end

      def certificate_data
        {
          web_adress: 'cosmeticru.com',
          drk_adress: '115184 г. Москва, Б. Татарская 35с3',
          company_name_and: ' и ',
          payer: nil, # @group_subscription.payer,
          student_passport_serie: @group_subscription.student_passport_series,
          student_passport_number: @group_subscription.student_passport_number,
          student_passport_issued: student_passport_issued,
          student_address: @group_subscription.student_passport_address,
          student_actual_address: @group_subscription.student_address,
        }
      end

      def course_start
        format_date_with_quotes(@group_subscription.group.fake? ? Date.current : @group_subscription.begin_on)
      end

      def course_end
        format_date_with_quotes(@group_subscription.group.fake? ? Date.current + 6.months : @group_subscription.end_on)
      end

      def student_passport_issued
        format_date_with_quotes(@group_subscription.student_passport_issued_on).to_s +
        " " +
        @group_subscription.student_passport_organisation.to_s
      end
    end
  end
end
