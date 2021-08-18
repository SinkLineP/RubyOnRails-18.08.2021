module Documents
  module Generators
    class FinalWorkSheet
      include DocBuilder
      include DocumentsHelper
      include ActionView::Helpers::NumberHelper

      def initialize(options={})
        @work_result = options[:item]
        @without_marks = options[:without_marks]
        @group = @work_result.group
        @course = @work_result.course
        @work = @work_result.work
        @date = @work_result.marked_on
        @students = options[:student_work_results] || @work_result.student_work_results
        @students.each_with_index { |s, i| s.index = i + 1 }
      end

      def generate
        build_doc('final_work_sheet', data)
      end

      private

      def data
        {
            students: ->(report) do
              report.add_table('STUDENTS', @students, header: true) do |t|
                t.add_column(:index, :index)
                t.add_column(:student_fio, :student_full_name)
                t.add_column(:content) { |item| @without_marks ? '' : item.display_content }
                t.add_column(:typography) { |item| @without_marks ? '' : item.display_typography }
                t.add_column(:protection) { |item| @without_marks ? '' : item.display_protection }
                t.add_column(:total) { |item| @without_marks ? '' : item.display_total_mark }
              end
            end,
            date: format_date_with_points(@date),
            group_name: @group.title,
            faculty_name: @course.faculty_title,
            teacher_fio: @group.instructor.try(:full_name)
        }
      end
    end
  end
end