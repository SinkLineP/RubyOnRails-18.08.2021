module CoursesShop
  class GroupsController < BaseController

    layout false

    before_action :authenticate_user!

    def show
      group_info = load_group_info!
      info_html = render_to_string(partial: 'courses_shop/group_subscriptions/group_popup_fields',
                                   locals: {group_info: group_info})

      render json: {info: info_html, lock: group_info.subscription_not_available?}
    end

    private

    def load_group_info!
      group = Group.find(params[:id])
      education_form = EducationForm.find_by(id: params[:education_form_id]) || EducationForm.offline
      subscription = current_user.group_subscriptions.find_by(id: params[:subscription_id])
      subscription ||= current_user.group_subscriptions.new
      subscription.assign_attributes(group: group, education_form: education_form)
      Groups::SubscriptionInfo.new(subscription)
    end
  end
end