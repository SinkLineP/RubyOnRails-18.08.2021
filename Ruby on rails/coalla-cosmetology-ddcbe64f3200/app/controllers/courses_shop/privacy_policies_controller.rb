module CoursesShop
  class PrivacyPoliciesController < BaseController
    def confirm
      current_user.update_columns(privacy_policy_confirmed: true) if user_signed_in?
      render json: { success: true }
    end
  end
end