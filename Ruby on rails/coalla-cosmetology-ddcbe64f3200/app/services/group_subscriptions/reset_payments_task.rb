module GroupSubscriptions
  class ResetPaymentsTask
    def self.run
      GroupSubscription
          .payment_not_completed
          .where('pending_payment_at <= ?', Time.current - 15.minutes)
          .update_all(pending_payment_at: nil)
    end
  end
end