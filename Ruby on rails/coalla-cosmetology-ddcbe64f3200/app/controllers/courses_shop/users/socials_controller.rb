module CoursesShop
  class Users::SocialsController < BaseController

    before_action :authenticate_user!, only: [:destroy]

    def destroy
      authentication = current_user.authentications.find_by(provider: params[:provider])
      authentication.destroy if authentication
      redirect_to edit_courses_shop_profile_path
    end

  end
end