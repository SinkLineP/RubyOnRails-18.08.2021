module GroupSubscriptions
  class Actualizer
    def initialize(subscription)
      @subscription = subscription
      @group_info = Groups::SubscriptionInfo.new(subscription)
    end

    def actualize
      return if group_info.subscription_available? && subscription.group_price

      group_price = group_info.selected_price
      if group_price.present? && group_info.subscription_available?
        subscription.update(group_price: group_price)
        return
      end

      new_group_price = detect_new_group_price
      if new_group_price
        subscription.update(group: new_group_price.group, group_price: new_group_price)
      else
        subscription.really_destroy!
      end
    end

    private

    def detect_new_group_price
      course = subscription.course
      new_group = course.nearest_groups.detect do |group|
        group_info.change_group(group)
        group_info.subscription_available?
      end
      return unless new_group
      group_info.selected_price
    end


    attr_reader :subscription, :group_info
  end
end