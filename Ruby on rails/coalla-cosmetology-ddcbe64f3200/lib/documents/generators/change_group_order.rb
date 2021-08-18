module Documents
  module Generators
    class ChangeGroupOrder
      include DocBuilder
      include DocumentsHelper
      include CertificateHelper

      def initialize(options={})
        @group_transfer = options[:item]
        @group_subscription = @group_transfer.group_subscription
        @number = options[:number]
        @date = options[:date]
        @student = @group_subscription.student
        @new_group = @group_transfer.new_group
        @old_group = @group_transfer.old_group
      end

      def generate
        build_doc('change_group_order', data)
      end

      private

      def data
        {
            order_number: @number,
            order_date: format_date_with_quotes(@date),
            student_name: names_array(@student, :dative).join(' '),
            new_group_number: @new_group.title,
            old_group_number: @old_group.title,
            old_program_name: @old_group.course.name,
            new_program_name: @new_group.course.name,
            education_form: @group_subscription.education_form_title.try(:mb_chars).try(:downcase),
            hours: @old_group.course.hours,
            old_begin_on: format_date(@old_group.begin_on),
            old_end_on: format_date(@old_group.end_on),
            new_begin_on: format_date(@new_group.begin_on),
            new_end_on: format_date(@new_group.end_on),
            program_volume: program_volume(@new_group.course.hours)
        }
      end
    end
  end
end