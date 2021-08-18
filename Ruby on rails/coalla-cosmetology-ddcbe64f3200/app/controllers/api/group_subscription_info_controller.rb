module Api
  class GroupSubscriptionInfoController < Api::ApplicationController
    def list
      @group_subscription = GroupSubscription.find_by(amocrm_id: params[:amocrm_id]) if params[:amocrm_id].present?
      @groups = Group.active.finished.ascending_name.to_a
      @discounts = Discount.active.ordered.to_a
      if @group_subscription
        @groups = [@group_subscription.group] + @groups if @groups.exclude?(@group_subscription.group)
        discount = @group_subscription.discount
        @discounts = [@group_subscription.discount] + @discounts if discount.present? && @discounts.exclude?(discount)
      end
      @promotions = Promotion.ordered_visible
      @education_forms = EducationForm.ordered
      @education_levels = EducationLevel.ordered
      @amo_modules = AmoModule.ordered
      @group_prices = GroupPrice
                          .where(group_id: params[:group_id],
                                 education_form_id: params[:education_form_id])
                          .ordered
      @module_subscriptions = @group_subscription && @group_subscription.module_subscriptions
    end
  end
end