module Documents
  module Generators
    class MultipleQuestionnaire
      include DocBuilder
      include DocumentsHelper
      include ActionView::Helpers::NumberHelper

      def initialize(options={})
        @order = options[:item]
        @group_subscriptions = @order.group_subscriptions
        @student = @order.user
      end

      def generate
        build_doc('questionnaire', data)
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
          course_short_name: @group_subscriptions.map { |gs| gs.course_display_name }.join('; '),
          education_form: @group_subscriptions.map { |gs| gs.education_form_short_title }.join('; '),
          price: "#{@order.full_price} руб.",
          payment_type: @order.full? ? 'единовременно' : 'рассрочка',
          period: @group_subscriptions.map { |gs| "#{format_date_with_points(gs.begin_on)} - #{format_date_with_points(gs.end_on)}" }.join('; '),
          payments: @group_subscriptions.map { |gs| gs.payments.map { |p| "#{p.amount} руб. - #{format_date_with_points(p.payed_on)}" }.join("\n") }.join(";\n"),
          discounts: "#{@order.discount_sum} руб.\n#{@group_subscriptions.map { |gs| discounts(gs) }.join("\n")}",
          schedule: @group_subscriptions.map { |gs| Common::ScheduleInfo.new(gs).text }.join('; '),
          practice: @group_subscriptions.map { |gs| gs.practice == :institute ? 'ДРК' : gs.practice_basis_title }.join('; '),
          payer: @group_subscriptions.map { |gs| payer_info(gs) }.join('; '),
          document_copies: document_copies,
          group: @group_subscriptions.map { |gs| gs.group_title }.join('; '),
          wear_size: @student.wear_size,
          not_loaded_documents: not_loaded_documents,
          academic_vacation_text: @group_subscriptions.map { |gs| academic_vacation_text(gs) }.join('; ')
        }
      end

      def discounts(group_subscription)
        discount = group_subscription.discount

        return unless discount

        if discount.composite?
          discount.discounts.map { |d| "#{d.title}, #{d.calculate(group_subscription.price)} руб." }.join("\n")
        else
          "#{discount.title}, #{discount.calculate(group_subscription.price)} руб."
        end
      end

      def payer_info(group_subscription)
        if group_subscription.payer_type_student?
          'Сам студент'
        else
          payment_requisite = group_subscription.payment_requisite
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
        @student.student_documents.map { |c| c.title_text }.join(",\s")
      end

      def not_loaded_documents
        types = @student.student_documents.map(&:document_type)
        StudentDocument.document_type.options.drop(1).select { |type| types.exclude?(type[1].to_s) }.map(&:first).join(",\s")
      end
    end
  end
end