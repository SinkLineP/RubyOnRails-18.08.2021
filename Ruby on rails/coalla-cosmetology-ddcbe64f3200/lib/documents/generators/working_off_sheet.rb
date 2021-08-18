module Documents
  module Generators
    class WorkingOffSheet
      include DocBuilder
      include DocumentsHelper
      include ActionView::Helpers::NumberHelper

      def initialize(options = {})
        @work_off_list = options[:item]
        subscription = @work_off_list.group_subscription
        @group = subscription.group
        @student = subscription.student
        @exam = @work_off_list.exam?
      end

      def generate
        build_doc("working_off_sheet#{@exam ? '_exam' : ''}", data)
      end

      private

      def data
        {
          last_name: @student.last_name,
          first_name: @student.first_name,
          middle_name: @student.middle_name,
          variant: @work_off_list.variant_text,
          date: format_date_with_points(@work_off_list.processed_on),
          group_title: @group.title,
          period: @work_off_list.hours,
          work: @work_off_list.work.title,
          payment: @work_off_list.working_off_type_text,
          instructor_name: @work_off_list.instructor.try(:full_name)
        }
      end
    end
  end
end