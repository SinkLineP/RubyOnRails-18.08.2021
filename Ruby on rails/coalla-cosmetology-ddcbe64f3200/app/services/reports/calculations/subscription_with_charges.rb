module Reports
  module Calculations
    class SubscriptionWithCharges
      attr_reader :subscription,
                  :student,
                  :course,
                  :query,
                  :sms_price,
                  :campaign

      delegate :sum_values_for_campaign,
               :subscriptions_count_for_campaign,
               :subscriptions_price_sum_for_campaign,
               :subscriptions_count,
               :total_subscriptions_count,
               :sms_count_for_subscription,
               :search_promotion_campaign_charges,
               to: :query
      delegate :name, to: :campaign
      delegate :price_without_discount,
               :discount_amount,
               :sale_success_on,
               :group,
               to: :subscription
      delegate :cost, to: :course, prefix: true
      delegate :name, to: :campaign, prefix: true, allow_nil: true
      delegate :amo_created_at, :full_name, to: :student, prefix: true, allow_nil: true

      def initialize(subscription, query, sms_price)
        @subscription = subscription
        @student = @subscription.student
        @campaign = @student.campaign
        @course = @subscription.course
        @sms_price = sms_price
        @query = query
      end

      def ltv
        price_without_discount - (attraction_charges + discount_amount + sms_cost + course_cost)
      end

      def attraction_charges
        first_div = campaign_subscriptions.to_f != 0 ? campaign_charges / campaign_subscriptions : 0
        second_div = search_promotion_campaign_charges.to_f != 0 ? search_promotion_campaign_charges / total_subscriptions_count : 0
        first_div + second_div
      end

      def campaign_subscriptions
        subscriptions_count_for_campaign(campaign) if campaign
      end

      def campaign_charges
        sum_values_for_campaign(campaign, 'charges') if campaign
      end

      def sms_cost
        sms_count_for_subscription(subscription) * sms_price
      end

    end
  end
end