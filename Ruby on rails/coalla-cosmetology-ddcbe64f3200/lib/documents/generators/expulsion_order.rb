module Documents
  module Generators
    class ExpulsionOrder
      include DocBuilder
      include DocumentsHelper
      include ActionView::Helpers::NumberHelper

      def initialize(options={})
        @expulsion = options[:item]
        @students = @expulsion.expelled_students.each_with_index { |s, i| s.index = i + 1 }.to_a
        @students.each_with_index { |s, i| s.index = i + 1 }
        @course = @expulsion.course
        @number = options[:number]
        @date = options[:date]
      end

      def generate
        build_doc('expulsion_order', data)
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
            date: format_date_with_quotes(@date),
            number: @number,
            hours: format_duration(@course.hours),
            course_name: @course.name,
            expulsion_date: format_date_with_points(@expulsion.expelled_on),
            basis: basis
        }
      end

      def basis
        reasons = []
        reasons << 'личные заявления обучающихся' if @expulsion.personal?
        reasons << 'непосещение занятий' if @expulsion.non_attendance?
        reasons << 'окончание обучения' if @expulsion.at_the_end_of_education?
        reasons.join("\n")
      end
    end
  end
end