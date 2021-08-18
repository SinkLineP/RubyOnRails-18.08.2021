module Reports
  module Calculations
    class DataQuery
      attr_accessor :begin_on, :end_on

      def initialize(begin_on, end_on)
        @begin_on = begin_on
        @end_on = end_on
      end

      def sum_values_for_campaign(campaign, index_name)
        sum_values.values_at([campaign.id,index_name]).first || 0
      end

      def subscriptions_count_for_campaign(campaign)
        subscriptions_count.values_at(campaign.id).first || 0
      end

      def subscriptions_price_sum_for_campaign(campaign)
        subscriptions_price_sum.values_at(campaign.id).first || 0
      end

      def sms_count_for_subscription(subscription)
        subscription_sms = sum_values.values_at([subscription.student_id,subscription.id]).first || 0
        student_sms = (sum_values.values_at([subscription.student_id,nil]).first || 0) / subscriptions_count_for_student(subscription.student)

        (subscription_sms + student_sms)
      end

      def subscriptions_count_for_student(student)
        subscriptions_grouped_by_student.values_at(student.id).first || 0
      end

      def sum_values
        @sum_values ||= CampaignIndex.where(created_on: begin_on..end_on).group(:campaign_id, :name).sum(:value)
      end

      def subscriptions_price_sum
        @subscriptions_price_sum ||= success_subscriptions_grouped_by_campaign.sum(:price)
      end

      def sms_grouped_by_subscription_and_user
        @sms_grouped_by_subscription_and_user ||= Sms.where(created_at: begin_on..end_on).group('user_id, group_subscription_id')
      end

      def subscriptions_grouped_by_student
        @subscriptions_grouped_by_student ||= GroupSubscription.joins(:student).where(sale_success_on: begin_on..end_on).group('student_id').count
      end

      def subscriptions_count
        @subscriptions_count ||= success_subscriptions_grouped_by_campaign.count
      end

      def total_subscriptions_count
        @total_subscriptions_count ||= GroupSubscription.joins(:student).where(sale_success_on: begin_on..end_on).count
      end

      def search_promotion_campaign_charges
        sum_values_for_campaign(search_promotion_campaign, 'charges')
      end

      private

      def success_subscriptions_grouped_by_campaign
        GroupSubscription.joins(:student).where(sale_success_on: begin_on..end_on).group('users.campaign_id')
      end

      def search_promotion_campaign
        @search_promotion_campaign ||= Campaign.search_promotion
      end
    end
  end
end