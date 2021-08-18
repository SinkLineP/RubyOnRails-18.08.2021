module GroupSubscriptions
  class Payments

    def initialize(subscription)
      @group_subscription = subscription
      @fact_payments = PaymentLog.where(group_id: subscription.group_id, student_id: subscription.student_id).to_a
      @plan_payments = subscription.payments.to_a
    end

    def paid_status
      return 'payment_not_completed' if @group_subscription.pending_payment_at?

      return (group_subscription.expired? ? 'archive' : 'full_paid') if fact >= plan_total

      fact < current_plan ? 'debts' : 'pending_payment'
    end

    def archived?
      fact >= plan_total && group_subscription.expired?
    end

    def paid?
      %w(archive full_paid).include?(paid_status)
    end

    def debts_sum
      plan_total - fact
    end

    def current_debt_sum
      current_plan - fact
    end

    def current_debt?
      current_debt_sum > 0
    end

    def current_plan
      plan_payments.select { |p| p.payed_on && p.payed_on <= Date.current }.sum(&:amount)
    end

    def last_plan_payment_date
      plan_payment_debt_dates(fact, Date.current).first
    end

    def plan_payment_debt_dates(fact_sum, current_date)
      dates = plan_payments.map(&:payed_on).compact.select {|p| p <= current_date}.sort
      result = dates.map do |date|
        plan_sum = plan_payments.select {|p| p.payed_on && p.payed_on <= date}.sum(&:amount) || 0
        next unless plan_sum > fact_sum
        date
      end
      result.compact
    end

    def plan_total
      plan_payments.sum(&:amount)
    end

    def fact
      fact_payments.sum(&:amount)
    end

    def completed_payments
      temp_fact = fact

      plan_payments.select do |payment|
        temp_fact -= payment.amount
        temp_fact >= 0
      end
    end

    def overpaid
      fact - completed_payments.sum(&:amount)
    end

    def pending_payments
      plan_payments.select { |payment| !completed_payments.include?(payment) }
    end

    private

    attr_reader :group_subscription, :plan_payments, :fact_payments
  end
end