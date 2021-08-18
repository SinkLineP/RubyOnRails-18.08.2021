module Calls
  class NotificationTask
    MAXIMUM_CALLS = 3

    class << self
      def run
        subscriptions = GroupSubscription
                          .preload(:call_results, :student)
                          .actual
                          .where(sale_success_on: (Date.today.beginning_of_day - 30.days)..(Date.today.end_of_day - 1.day)).group_by(&:student).map do |_student, group_subscriptions|
          group_subscriptions.max_by(&:price)
        end.select do |subscription|
          subscription.call_results.none?(&:success?) && subscription.call_results.count < CallResult::MAXIMUM_CALLS
        end
        call_results = subscriptions.map { |subscription| subscription.call_results.create! }
        return if call_results.blank?
        csv = Calls::CallListBuilder.new(call_results).build
        voximplant = Calls::Voximplant.new
        voximplant.create_call_list(csv)
      end
    end
  end
end