module Documents
  module Generators
    class EducationCertificate
      include DocBuilder
      include DocumentsHelper

      def initialize(options={})
        @group_subscription = options[:item]
        @number = options[:number]
        @date = options[:date]
        @with_print = options[:with_print]
      end

      def generate
        build_doc("education_certificate#{@with_print ? '_with_print' : ''}", data)
      end

      private

      def data
        {
            number: @number,
            date: format_date_with_quotes(@date),
            student: full_name_form(@group_subscription.student_full_name, :dative),
            program_name: @group_subscription.course_name,
            begin_date: format_date_with_quotes(@group_subscription.begin_on),
            end_date: format_date_with_quotes(@group_subscription.end_on)
        }
      end
    end
  end
end