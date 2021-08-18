module Admin
  module GroupSubscriptionsHelper

    def subscription_class(group_subscription)
      return 'debts' if group_subscription.has_debts?
      return 'academic-vacation' if group_subscription.in_academic_vacation?
      ''
    end

    def module_label(group_subscription)
      return 'M' if group_subscription.amo_module
      return 'Ф' if group_subscription.created_from_module?
      ''
    end

  end
end