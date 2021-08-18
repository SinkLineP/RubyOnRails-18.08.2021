module Documents
  module Generators
    class AttendanceLog
      include DocBuilder
      include DocumentsHelper
      include ActionView::Helpers::NumberHelper

      def initialize(options={})
        @group = options[:item]
        @month_number = options[:month_number]
        @date = options[:date]
        @practices_count = options[:practices_count]
        @practices = @group.practices.first(@practices_count)
        @month_days = get_days_of_month(@group.practices_range_dates[:begin]..@group.practices_range_dates[:end], @month_number)
        beginning_of_month = Date.new(options[:year_number], options[:month_number], @month_days.first)
        end_of_month = Date.new(options[:year_number], options[:month_number], @month_days.last)
        @students = []
        students_array = @group.students
                           .joins(:group_subscriptions)
                           .merge(GroupSubscription.not_expelled.actual)
                           .uniq
                           .by_alphabet
                           .to_a
        students_array.each do |student|
          subscription = student.subscription_by_group(@group.id)
          if subscription.academic_vacation
            next if subscription.was_in_vacation_while_practice?(beginning_of_month, end_of_month)
          end
          @students << student
          @students << Student.new(second_practice_date: @practices.last.start_time.strftime('%H:%M')) if @practices_count > 1
        end
        @students.select(&:persisted?).each_with_index do |s, i|
          s.index = i + 1
          s.first_practice_date = @practices.first.start_time.strftime('%H:%M')
        end
        empty_users = [Student.new(second_practice_date: ''), Student.new(second_practice_date: '')]
        @check_list_students = @students.select(&:persisted?)
        @check_list_students += empty_users
        @students += empty_users
        @students += empty_users if @practices_count > 1
      end

      def generate
        build_doc(@practices_count > 1 ? 'attendance_multiple_log' : 'attendance_log', data)
      end

      private

      def data
        result = {
          students: ->(report) do
            report.add_table('STUDENTS', @students, header: true) do |t|
              t.add_column(:index, :index)
              t.add_column(:student_name, :full_name)
              t.add_column(:practice_date) { |item| item.persisted? ? item.first_practice_date : item.second_practice_date } if @practices_count > 1
            end
            report.add_table('STUDENTS_2', @check_list_students, header: true) do |t|
              t.add_column(:student_name, :full_name)
            end
          end,
          education_dates: practices_education_dates_text(@group.practices.first(2)),
          group_number: @group.title,
          practice_time: @group.practices_time_text
        }
        1.upto(31) do |n|
          result["date_#{n}".to_sym] = @month_days.include?(n) ? get_date_text(n, @month_number) : ''
        end
        result
      end
    end
  end
end