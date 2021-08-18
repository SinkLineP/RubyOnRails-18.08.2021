module Amocrm
  module Operations
    class CreateDefaultSubscription
      def initialize(params = {})
        @params = params
        @student = @params.delete(:student)
        @shop = @params.delete(:shop)
        @student ||= register_student
      end

      def perform
        course = Course.default_courses.first
        group = course.try(:groups).try(:first)
        return unless group
        subscription = @student.group_subscriptions.with_deleted.first
        subscription = @student.group_subscriptions.build(group: group,
                                                          begin_on: group.begin_on,
                                                          end_on: group.end_on,
                                                          education_form: group.education_form) unless subscription
        subscription.save
        return if subscription.invalid?
        GroupSubscriptions::AmoLeadActionJob.enqueue(:create,
                                                     subscription_id: subscription.id,
                                                     roistat: @params[:roistat],
                                                     roistat_marker: @params[:roistat_marker],
                                                     message: @params[:message])
      end

      private

      def register_student
        student = ::Student.find_by(email: @params[:email])
        return student if student
        password = Devise.friendly_token.first(8)
        student = ::Student.create!(email: @params[:email],
                                    full_name: @params[:name],
                                    password: password,
                                    source: @shop.code.to_s)
        student.add_phone(@params[:phone_number]) if @params[:phone_number].present?
        if @shop.cosmetic?
          Mindbox::XmlApiOperation.enqueue('FirstEmail',
                                           email: student.email,
                                           password: password)
        else
          CoursesShop::CoursesShopMailer.sign_in(student).deliver!
        end
        student
      end
    end
  end
end