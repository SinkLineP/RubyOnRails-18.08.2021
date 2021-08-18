module Documents
  module Generators
    class GroupList
      include DocBuilder
      include DocumentsHelper
      include ActionView::Helpers::NumberHelper

      def initialize(options={})
        @group = options[:item]
        @course = @group.course
        @practice = @group.practices.first
        @students = @group.students
                      .joins(:group_subscriptions)
                      .merge(GroupSubscription.not_expelled.actual)
                      .uniq
                      .by_alphabet
                      .to_a + [Student.new, Student.new]
      end

      def generate
        build_doc('group_list', data)
      end

      private

      def data
        {
          students: ->(report) do
            report.add_table('STUDENTS', @students, header: true) do |t|
              t.add_column(:student_name, :full_name)
              t.add_column(:student_phone) { |item| item.phones.reject(&:blank?).join(', ') }
              t.add_column(:student_email, :email)
              t.add_column(:training_form) { |item| item.group_subscription_for_course(@course).try(:education_form_short_title) }
              t.add_column(:course_name) { |item| item.persisted? ? @course.short_name : '' }
              t.add_column(:other_courses) { |item| item.other_courses(@course).map(&:short_name).join(', ') }
              t.add_column(:student_notes) { |item| item.persisted? ? item.notes_text(@group) : '' }
              t.add_column(:practice_entrance) { |item| item.group_subscription_for_course(@course).try(:practice_entrance) }
              t.add_column(:amo_module) { |item| item.group_subscription_for_course(@course).try(:amo_module_text) }
            end
          end,
          education_start_date: format_date_with_points(@group.begin_on),
          education_end_date: format_date_with_points(@group.end_on),
          practice_start_date: format_date_with_points(@practice.try(:begin_on)),
          practice_end_date: format_date_with_points(@practice.try(:end_on)),
          group_name: @group.title,
          education_time: time_range_format(@group.start_time, @group.end_time),
          practice_time: time_range_format(@practice.try(:start_time), @practice.try(:end_time))
        }
      end
    end
  end
end