module Reports
  module Calculations
    class StudentWithLtv
      attr_reader :student, :subscriptions

      delegate :full_name, to: :student, prefix: true, allow_nil: true

      def initialize(student, subscriptions)
        @student = student
        @subscriptions = subscriptions
      end

      def ltv
        price_without_discount - (attraction_charges + discount_amount + sms_cost + course_cost)
      end

      def price_without_discount
        subscriptions.sum(&:price_without_discount)
      end

      def attraction_charges
        subscriptions.sum(&:attraction_charges)
      end

      def sms_cost
        subscriptions.sum(&:sms_cost)
      end

      def course_cost
        subscriptions.sum(&:course_cost)
      end

      def discount_amount
        subscriptions.sum(&:discount_amount)
      end

      def groups_list
        subscriptions.map { |s| s.group.try(:title) }.reject(&:blank?).join(",\s")
      end
    end
  end
end