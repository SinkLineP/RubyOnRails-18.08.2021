module Documents
  module Generators
    class OrderContract
      include DocBuilder
      include DocumentsHelper
      include ActionView::Helpers::NumberHelper

      def initialize(options={})
        @order = options[:item]
        @group_subscription = @order.first_subscription
        @number = options[:number]
        @date = options[:date]

        @options = options
        @builder_class = @group_subscription.generate_payer_agreement? ? OrderContractBuilders::AnotherContract : OrderContractBuilders::StudentContract
      end

      def generate
        build_doc("order_contract#{@group_subscription.generate_payer_agreement? ? '_another' : ''}", data)
      end

      def data
        {
            number: @number,
            date: format_date_with_quotes(@date),
            student: @group_subscription.student_full_name,
            program: subscriptions.map{|subscription| "«#{course_name(subscription)}» в объеме #{course_hours(subscription)} #{course_hours_str(subscription)}"}.join(",\n"),
            faculty: subscriptions.map{|subscription| "факультет #{subscription.group_subscription.faculty_title}" }.uniq.join(','),
            standart: subscriptions.map{|subscription| "по «#{course_name(subscription)}» – #{course_hours(subscription)} #{course_hours_str(subscription)}"}.join("\n"),
            study_dates: subscriptions.map{|subscription| "по «#{course_name(subscription)}» –  с #{course_start(subscription)} по #{course_end(subscription)}"}.join("\n"),
            schedules: subscriptions.map{|subscription| "по «#{course_name(subscription)}» – #{course_schedule(subscription)}"}.join("\n"),
            courses: (subscriptions_online + subscriptions_offline).join("\n"),
            documents_list: subscriptions.map{|subscription| "«#{course_name(subscription)}» – #{subscription.group_subscription.documents_list}"}.join("\n"),
            prices: subscriptions.map{|subscription| "«за #{course_name(subscription)}» – #{format_price_for_contract(subscription.group_subscription.price, false)}"}.join(",\n"),
            payment_types: subscriptions.map{|subscription| "«за #{course_name(subscription)}» – #{payment_type(subscription.group_subscription)}"}.join(",\n"),
            appendix_date: format_date_with_quotes(@group_subscription.appendix_signed_on)

        }.merge(@builder_class.new(@options).build_data)
      end


      def subscriptions
        @order.order_group_subscriptions.order_by_position
      end

      def subscriptions_online
        subscriptions_online = @order.order_group_subscriptions.academic_vacation.order_by_position
        subscriptions_online.present? ? subscriptions_online.map{|subscription| "«#{course_name(subscription)}»"}+['Очная с применением дистанционных образовательных технологий.'] : []
      end

      def subscriptions_offline
        subscriptions_offline = @order.order_group_subscriptions.not_academic_vacation.order_by_position
        subscriptions_offline.present? ?  subscriptions_offline.map{|subscription| "«#{course_name(subscription)}»"}+['Очная.'] : []
      end

      def course_name(subscription)
        subscription.group_subscription.course_name
      end

      def course_hours(subscription)
        subscription.group_subscription.course_hours.to_i
      end

      def course_hours_str(subscription)
        Russian.p(subscription.group_subscription.course_hours.to_i, 'академический час', 'академических часа', 'академических часов')
      end

      def course_start(subscription)
        group = subscription.group_subscription.group
        format_date_with_quotes(group.fake? ? Date.current : subscription.group_subscription.begin_on)
      end

      def course_end(subscription)
        group = subscription.group_subscription.group
        format_date_with_quotes(group.fake? ? Date.current + 6.months : subscription.group_subscription.end_on)
      end

      def course_schedule(subscription)
        Common::ScheduleInfo.new(subscription.group_subscription).text
      end

    end
  end
end