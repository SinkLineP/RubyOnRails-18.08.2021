module Documents
  module Generators
    class ExpulsionPeriodOrder
      include DocBuilder
      include DocumentsHelper
      include ActionView::Helpers::NumberHelper

      def initialize(options={})
        items = options[:items]
        @grouped_subscriptions = []
        items.each do |item|
          group_subscription = OpenStruct.new
          group_subscription.group = Group.find(item.first)
          group_subscription.course = group_subscription.group.course
          students = []
          item.second.map(&:student).uniq.each_with_index do |student, idx|
            students << OpenStruct.new(index: idx + 1, full_name: student.full_name)
          end
          group_subscription.students = students
          @grouped_subscriptions << group_subscription
        end
        @number = options[:number]
        @date = options[:date]
      end

      def generate
        build_doc('expulsion_period_order', data)
      end

      private

      def data
        {
          students_section: ->(report) do
            report.add_section('STUDENTS_SECTION', @grouped_subscriptions) do |s|
              s.add_table('STUDENTS', :students, header: true) do |t|
                t.add_column(:index) { |item| item.index }
                t.add_column(:full_name) { |item| item.full_name }
              end
              s.add_field(:hours) { |gs| format_duration(gs.course.hours) }
              s.add_field(:course_name) { |gs| gs.course.name }
              s.add_field(:expulsion_date) { |gs| format_date_with_points(@date) }
            end
          end,
          date: format_date_with_quotes(@date),
          number: @number,
          basis: 'окончание обучения'
        }
      end
    end
  end
end