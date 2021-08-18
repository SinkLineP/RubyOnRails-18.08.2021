module GroupSubscriptions
  class OrderSubscriptionsNotifier
    def initialize(order)
      @order = order
      @group_subscriptions = @order.group_subscriptions
      @not_zero_subscription = @order.not_zero_subscriptions.first
      @student = @order.user
    end

    def notify!
      send_welcome_mail!
      order.not_zero_subscriptions.each do |subscription|
        GroupSubscriptions::Notifier.new(subscription).notify_without_welcome!
      end
    end

    private

    def send_welcome_mail!
      return unless not_zero_subscription
      if student.welcome_sent?
        CosmetologyMailer.notify_about_new_courses(student, not_zero_subscription).deliver!
        return
      end

      password = Devise.friendly_token(8)
      student.update!(password: password, welcome_sent_at: Time.current)
      CosmetologyMailer.sign_up(student, not_zero_subscription).deliver!
    end

    attr_reader :group_subscriptions, :student, :order, :not_zero_subscription
  end
end