module Documents
  module Generators
    module SheetBuilders
      class WorkWithoutSubExercises
        include DocumentsHelper
        include ActionView::Helpers::NumberHelper

        SUBTOTAL = 20

        def initialize(work_result, options)
          @work_result = work_result
          @options = options
          @group = @work_result.group
          @course = @work_result.course
          @work = @work_result.work
          @exercises = @work.exercises
          @students = options[:student_work_results] || @work_result.student_work_results
          @absent = options[:absent]
          @students.each_with_index { |s, i| s.index = i + 1 }
        end

        def build_data
          result = {
              students: ->(report) do
                report.add_table('STUDENTS', @students, header: true) do |t|
                  t.add_column(:index, :index)
                  t.add_column(:student_fio, :student_full_name)
                  t.add_column(:presence) { |item| @options[:without_marks] ? '' : item.display_presence }
                  t.add_column(:customer_care) { |item| @options[:without_marks] ? '' : item.display_customer_care }
                  t.add_column(:hygiene) { |item| @options[:without_marks] ? '' : item.display_hygiene }
                  t.add_column(:ergonomic) { |item| @options[:without_marks] ? '' : item.display_ergonomic }
                  t.add_column(:student_absent, :absent) { |item| item.absent? ? 'V' : '' }
                  t.add_column(:subtotal, :subtotal) { |item| item.absent? || @options[:without_marks] ? '' : (item.subtotal == 0 ? '' : item.subtotal) }
                  @work.exercises.each_with_index do |exercise, i|
                    t.add_column("exercise_#{i+1}_mark".to_sym) do |item|
                      item.absent? || @options[:without_marks] ? '' : item.exercise_results.detect{|r| r.exercise == exercise}.try(:mark)
                    end
                  end
                  t.add_column(:exercise_total) do |item|
                    item.absent? || @options[:without_marks] ? '' : (item.exercise_results.sum(:mark) + item.subtotal == 0 ? '' : item.exercise_results.sum(:mark) + item.subtotal)
                  end
                end
              end,
              exercise_total_max: @work.with_sheet_columns? ? @exercises.sum(:max_mark) + (@work.hairdresser_work? ? 15 : SUBTOTAL) : @exercises.sum(:max_mark),
              discipline_name: "#{@work.full_title} #{@absent ? '(повторная)' : ''}",
              group_name: @group.title,
          }

          @exercises.to_a.each_with_index do |exercise, i|
            result["exercise_#{i+1}".to_sym] = exercise.text
            result["exercise_#{i+1}_max".to_sym] = exercise.max_mark
          end

          result
        end
      end
    end
  end
end