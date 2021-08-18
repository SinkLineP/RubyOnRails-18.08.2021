module RedirectForCourses
  extend ActiveSupport::Concern

  included do
    rescue_from CanCan::AccessDenied do |exception|
      if !user_signed_in?
        redirect_to root_path
      elsif current_user.student?
        redirect_to progress_path, alert: exception.message
      else
        redirect_to after_sign_in_path_for(current_user)
      end
    end
  end
end