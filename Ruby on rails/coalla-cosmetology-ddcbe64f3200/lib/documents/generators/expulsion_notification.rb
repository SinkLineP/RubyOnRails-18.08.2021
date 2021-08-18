module Documents
  module Generators
    class ExpulsionNotification
      include DocBuilder
      include DocumentsHelper

      def initialize(options={})
        @group_subscription = options[:item]
        @number = options[:number]
        @date = options[:date]
        @lectures = @group_subscription.not_passed_lectures.map(&:description).map{|l| "«#{l}»"}.join(",\s")
      end

      def generate
        build_doc('expulsion_notification', data)
      end

      private

      def data
        {
            number: @number,
            date: format_date_with_quotes(@date),
            student: full_name_form(@group_subscription.student_full_name, :accusative),
            group: @group_subscription.group_title,
            course: @group_subscription.course_name,
            expulsion_date: format_date_with_quotes(@date + 14.days),
            lectures: @lectures
        }
      end
    end
  end
end