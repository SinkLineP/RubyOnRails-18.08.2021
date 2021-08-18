module Reports
  module Calculations
    class CampaignWithValues
      include Calculator

      attr_reader :campaign, :query

      delegate :sum_values_for_campaign, :subscriptions_count_for_campaign, :subscriptions_price_sum_for_campaign, to: :query
      delegate :name, to: :campaign

      def initialize(campaign, query)
        @campaign = campaign
        @query = query
      end

      def calls
        sum_values_for_campaign(campaign, 'calls').to_i
      end

      def shows
        sum_values_for_campaign(campaign, 'shows').to_i
      end

      def visits
        sum_values_for_campaign(campaign, 'visits').to_i
      end

      def clicks
        result = sum_values_for_campaign(campaign, 'clicks').to_i
        result == 0 ? visits : result
      end

      def requests
        sum_values_for_campaign(campaign, 'requests').to_i
      end

      def charges
        sum_values_for_campaign(campaign, 'charges')
      end

      def subscriptions
        subscriptions_count_for_campaign(campaign)
      end

      def profit
        subscriptions_price_sum_for_campaign(campaign)
      end
    end
  end
end