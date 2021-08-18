module Documents
  module Generators
    class Questionnaire
      include DocBuilder
      include DocumentsHelper
      include ActionView::Helpers::NumberHelper

      def initialize(options={})
        @group_subscription = options[:item]
        @student = @group_subscription.student
      end

      def generate
        template_name = @group_subscription.government? ? 'questionnaire_government' : 'questionnaire'
        build_doc(template_name, data)
      end

      private

      def data
        {
            first_name: @student.first_name,
            last_name: @student.last_name,
            middle_name: @student.middle_name,
            phones: @student.phones_string,
            email: @student.email,
            translit_name: @student.translit_name,
            course_short_name: @group_subscription.course_display_name,
            education_form: @group_subscription.education_form_short_title,
            price: "#{@group_subscription.price} руб.",
            payment_type: @group_subscription.payments.count == 1 ? 'единовременно' : 'рассрочка',
            period: "#{format_date_with_points(@group_subscription.begin_on)} - #{format_date_with_points(@group_subscription.end_on)}",
            payments: @group_subscription.payments.map { |p| "#{p.amount} руб. - #{format_date_with_points(p.payed_on)}" }.join("\n"),
            discounts: discounts,
            schedule: Common::ScheduleInfo.new(@group_subscription).text,
            practice: @group_subscription.practice == :institute ? 'ДРК' : @group_subscription.practice_basis_title,
            payer: payer_info,
            document_copies: document_copies,
            group: @group_subscription.group_title,
            wear_size: @student.wear_size,
            not_loaded_documents: not_loaded_documents,
            academic_vacation_text: academic_vacation_text(@group_subscription)
        }
      end

      def discounts
        discount = @group_subscription.discount

        return unless discount

        if discount.composite?
          discount.discounts.map { |d| "#{d.title}, #{d.calculate(@group_subscription.price)} руб." }.join("\n")
        else
          "#{discount.title}, #{discount.calculate(@group_subscription.price)} руб."
        end
      end

      def payer_info
        if @group_subscription.payer_type_student?
          'Сам студент'
        else
          payment_requisite = @group_subscription.payment_requisite
          return '' unless payment_requisite
          <<EOF
#{payment_requisite.name}
Адрес: #{payment_requisite.address}
ИНН/КПП #{payment_requisite.inn}/#{payment_requisite.kpp}
Р/счет #{payment_requisite.account}, Банк #{payment_requisite.bank}
К/счет #{payment_requisite.correspondent_account}, БИК #{payment_requisite.bik}
Телефон #{payment_requisite.phone}, Email #{payment_requisite.email}
EOF
        end
      end

      def document_copies
        copies = @group_subscription.student.student_documents
        copies.map { |c| c.title_text }.join(",\s")
      end

      def not_loaded_documents
        types = @group_subscription.student.student_documents.map(&:document_type)
        StudentDocument.document_type.options.drop(1).select{|type| types.exclude?(type[1].to_s)}.map(&:first).join(",\s")
      end
    end
  end
end
