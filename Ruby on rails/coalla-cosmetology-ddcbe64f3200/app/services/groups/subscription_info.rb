module Groups
  class SubscriptionInfo

    attr_reader :group, :education_form, :subscription

    def initialize(subscription)
      @subscription = subscription
      @group = subscription.group
      @education_form = subscription.education_form
    end

    def change_group(group)
      @group = group
      @prices = nil
    end

    def prices
      @prices ||= load_visible_prices
    end

    def free_places
      return 0 if group.blank? || education_form.blank?
      education_form.online? ? group.distances_free_place : group.academics_free_place
    end

    def subscription_available?
      prices.present? && free_places > 0
    end

    def subscription_not_available?
      !subscription_available?
    end

    def selected_price
      prices.find { |price| price == subscription.try(:group_price) } || prices.first
    end

    private

    def load_visible_prices
      return [] if group.blank? || education_form.blank?

      prices_scope = group_prices.with_education_form(education_form.id).ordered

      exceptional_payment = prices_scope.detect(&:one_time_payment_with_early_booking?)

      if !exceptional_payment || exceptional_payment.expired?
        return prices_scope.reject(&:one_time_payment_with_early_booking?)
      end

      [exceptional_payment] + prices_scope.reject(&:one_time_payment?)
    end

    delegate :prices, to: :group, prefix: true
  end
end