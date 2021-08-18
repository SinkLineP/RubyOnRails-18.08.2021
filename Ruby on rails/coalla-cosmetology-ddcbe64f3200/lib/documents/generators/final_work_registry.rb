module Documents
  module Generators
    class FinalWorkRegistry
      include DocBuilder
      include DocumentsHelper
      include ActionView::Helpers::NumberHelper

      def initialize(options={})
        @group = options[:item]
        @code = options[:code]
        @date = options[:date]
        @education_document = EducationDocument.find_by(code: @code)
        @education_document_name = @education_document.try(:title)
        course_document = @group.course.course_documents.detect { |d| d.education_document == @education_document && d.program_name.present? }
        @program_name = course_document.try(:program_name) || @group.course_name
        @subscriptions = @group.subscriptions
                           .joins(:subscription_documents, :student)
                           .merge(GroupSubscription.not_expelled.actual)
                           .where(subscription_documents: { education_document: @education_document })
        @students = @subscriptions.joins(:student).order('users.last_name', 'users.first_name', 'users.middle_name').map(&:student)
        @students.each_with_index do |student, i|
          student.set_education_dates(@group.id)
          student.set_document_params(@group.id, @code)
          student.index = i + 1
        end
      end

      def generate
        build_doc('final_work_registry', data)
      end

      private

      def data
        {
          students: ->(report) do
            report.add_table('STUDENTS', @students, header: true) do |t|
              t.add_column(:index, :index)
              t.add_column(:student_name, :full_name)
              t.add_column(:education_start, :begin_on)
              t.add_column(:education_end, :end_on)
              t.add_column(:document_date, :generation_date)
              t.add_column(:number, :registration_number)
              t.add_column(:blank_number, :blank_number)
            end
          end,
          generation_date: format_date_with_points(@date),
          group_number: @group.title,
          registry_name: @education_document_name.to_s,
          program_name: @program_name,
        }
      end
    end
  end
end