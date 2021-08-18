class SubscriptionNotificationsController < ApplicationController

  def unsubscribe
    email, notification_type = SymmetricEncryption.decrypt(params[:token]).split('|')
    student = Student.find_by(email: email)
    return unless student
    student.rejected_subscriptions.create(notification_type: notification_type)
  end
end