module Amocrm
  module Operations
    class CreatePromoSubscription
      def initialize(params = {})
        @params = params
        @shop = @params.delete(:shop)
        course_id = @params.delete(:course_id)
        @course = Course.find(course_id)
        @is_blog = @params.delete(:is_blog)
      end

      def perform
        student = register_student
        group = @course.groups.detect(&:fake?) || @course.groups.first
        subscription = student.group_subscriptions.with_deleted.detect { |subscription| subscription.course == @course }
        subscription = student.group_subscriptions.build(group: group,
                                                         begin_on: group.begin_on,
                                                         end_on: group.end_on,
                                                         shop: @shop,
                                                         education_form: group.education_form) unless subscription
        subscription.save!
        message_prefix = @shop.barbershop? ? 'Заявка с парикмахерского сайта' : "Заявка с сайта ДРК#{@is_blog == 'y' ? '(БЛОГ)' : ''}"
        GroupSubscriptions::AmoLeadActionJob.enqueue(:create,
                                                     subscription_id: subscription.id,
                                                     roistat: @params[:roistat],
                                                     roistat_marker: @params[:roistat_marker],
                                                     message: "#{message_prefix}. Телефон: #{student.phone}. Имя: #{student.full_name}")
      end

      private

      def register_student
        email = "#{@params[:phone]}#{::Student::FAKE_EMAIL_POSTFIX}"
        student = ::Student.find_by(email: email)
        return student if student
        ::Student.create!(email: email,
                          phones: [@params[:phone]],
                          full_name: @params[:name],
                          password: Devise.friendly_token.first(8),
                          source: @shop.code.to_s)
      end
    end
  end
end