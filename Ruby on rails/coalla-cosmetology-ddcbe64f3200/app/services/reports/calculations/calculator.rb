module Reports
  module Calculations
    module Calculator
      def requets_on_clicks
        return nil if clicks == 0
        requests.to_f / clicks
      end

      def calls_on_clicks
        return nil if clicks == 0
        calls.to_f / clicks
      end

      def clicks_on_shows
        return nil if shows == 0
        clicks.to_f / shows
      end

      def subscriptions_on_requests
        return nil if requests == 0
        subscriptions.to_f / requests
      end

      def subscriptions_on_calls
        return nil if calls == 0
        subscriptions.to_f / calls
      end

      def subscriptions_on_clicks
        return nil if clicks == 0
        subscriptions.to_f / clicks
      end

      def net_profit
        profit - charges
      end

      def averrage_bill
        return nil if subscriptions == 0
        profit.to_f / subscriptions
      end

      def subscription_cost
        return nil if subscriptions == 0
        charges.to_f / subscriptions
      end

      def request_cost
        return nil if requests == 0
        charges.to_f / requests
      end

      def call_cost
        return nil if calls == 0
        charges.to_f / calls
      end

      def click_cost
        return nil if clicks == 0
        charges.to_f / clicks
      end

      def roi
        return nil if charges == 0
        (profit - charges) / charges.abs
      end
    end
  end
end