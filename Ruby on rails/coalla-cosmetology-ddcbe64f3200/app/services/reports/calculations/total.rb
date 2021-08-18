module Reports
  module Calculations
    class Total
      include Calculator

      attr_reader :campaigns

      def initialize(campaigns)
        @campaigns = campaigns
      end

      [
          :calls,
          :shows,
          :visits,
          :clicks,
          :requests,
          :charges,
          :subscriptions,
          :profit
      ].each do |method|
        define_method method do
          campaigns.sum { |c| c.send(method) }
        end
      end
    end
  end
end