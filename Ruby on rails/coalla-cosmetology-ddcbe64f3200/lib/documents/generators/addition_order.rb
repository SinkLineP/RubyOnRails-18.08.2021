module Documents
  module Generators
    class AdditionOrder
      include DocBuilder
      include DocumentsHelper
      include ActionView::Helpers::NumberHelper

      def initialize(options={})
        @group = options[:item]
        @students = @group.actual_students.to_a
        @students.each_with_index { |s, i| s.index = i + 1 }
        @course = @group.course
        @number = options[:number]
        @date = options[:date]
      end

      def generate
        build_doc('addition_order', data)
      end

      private

      def data
        {
            students: ->(report) do
              report.add_table('STUDENTS', @students, header: true) do |t|
                t.add_column(:index, :index)
                t.add_column(:full_name, :full_name)
              end
            end,
            order_date: format_date_with_quotes(@date),
            order_number: @number,
            course_start: format_date_with_points(@group.begin_on),
            course_end: format_date_with_points(@group.end_on),
            course_duration: format_duration(@course.hours),
            course_name: @course.name,
            course_appointment: I18n.t("course.appointment.#{@course.appointment}")
        }
      end
    end
  end
end