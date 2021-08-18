module CoursesShop
  class Users::PasswordsController < Devise::PasswordsController
    include RegistrationResource
    include ShopHelpers

    layout false

    def create
      @user = ::User.find_by_email(edit_password_params[:email])
      if @user
        @user.update!(password: Devise.friendly_token.first(8))
        CoursesShop::CoursesShopMailer.restore_password(@user, current_shop).deliver!
        render json: {otherPopup: {name: '#popup-password-success', link: "mailto:#{@user.email}"}}
      else
        message = t('devise.failure.not_found_in_database')
        render json: {errors: {email: [message]}}
      end
    end

    def edit_password_params
      params.require(:user).permit(:email)
    end
  end
end