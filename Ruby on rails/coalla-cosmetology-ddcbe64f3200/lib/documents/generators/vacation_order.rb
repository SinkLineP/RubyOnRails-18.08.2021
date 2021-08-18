module Documents
  module Generators
    class VacationOrder
      include DocBuilder
      include DocumentsHelper

      def initialize(options={})
        @group_subscription = options[:item]
        @number = options[:number]
        @date = options[:date]
      end

      def generate
        build_doc('vacation_order', data)
      end

      private

      def data
        {
            number: @number,
            date: format_date_with_quotes(@date),
            student: @group_subscription.student_full_name,
            group: @group_subscription.group_title,
            course: @group_subscription.course_name,
            hours: "#{@group_subscription.course_hours.to_i} #{Russian.p(@group_subscription.course_hours.to_i, 'академический час', 'академических часа', 'академических часов')}",
            begin_on: format_date(@group_subscription.vacation_begin_on),
            end_on: format_date(@group_subscription.vacation_end_on)
        }
      end
    end
  end
end