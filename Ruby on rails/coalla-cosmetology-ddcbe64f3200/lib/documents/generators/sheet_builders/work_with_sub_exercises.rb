module Documents
  module Generators
    module SheetBuilders
      class WorkWithSubExercises
        include DocumentsHelper
        include ActionView::Helpers::NumberHelper

        def initialize(work_result, options)
          @work_result = work_result
          @options = options
          @group = @work_result.group
          @course = @work_result.course
          @work = @work_result.work
          @exercises = @work.exercises
          @sub_exercises_max_sum = @work.exercises.first(3).sum{|ex| ex.exercises.sum(:max_mark)}
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
                  t.add_column(:student_absent, :absent) {|item| item.absent? ? 'V' : '' }
                  @exercises.first(3).each_with_index do |parent_exercise, idx|
                    parent_exercise.exercises.each_with_index do |exercise, i|
                      t.add_column("exercise_#{idx+1}_#{i+1}_mark".to_sym) do |item|
                        item.absent? || @options[:without_marks] ? '' : item.exercise_results.detect{|r| r.exercise == exercise}.try(:mark)
                      end
                    end
                  end
                  t.add_column(:exercise_4_mark) {|item| item.absent? || @options[:without_marks]  ? '' : item.exercise_results[9].mark}
                  t.add_column(:exercise_total) do |item|
                    item.absent? || @options[:without_marks]  ? '' : (item.exercise_results.sum(:mark) == 0 ? '' : item.exercise_results.sum(:mark))
                  end
                end
              end,

              group_name: @group.title,
              exercise_parent_4: @exercises[3].text,
              exercise_4_max: @exercises[3].max_mark,
              exercise_total_max: @exercises.sum(:max_mark) + @sub_exercises_max_sum,
              discipline_name: "#{@work.full_title} #{@absent ? '(повторная)' : ''}",
          }

          @exercises.first(3).to_a.each_with_index do |exercise, i|
            result["exercise_parent_#{i+1}".to_sym] = exercise.text
            result["exercise_parent_#{i+1}_max".to_sym] = exercise.max_mark

            exercise.exercises.each_with_index do |child_exercise, idx|
              result["exercise_#{i+1}_#{idx+1}_max".to_sym] = child_exercise.max_mark
              result["exercise_#{i+1}_#{idx+1}".to_sym] = child_exercise.text
            end
          end

          result
        end
      end
    end
  end
end