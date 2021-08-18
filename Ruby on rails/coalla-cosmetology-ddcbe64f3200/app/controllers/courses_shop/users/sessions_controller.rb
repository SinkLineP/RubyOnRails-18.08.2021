module CoursesShop
  class Users::SessionsController < Devise::SessionsController
    include RegistrationResource
    include ShopHelpers

    before_action do
      store_location_for(:user, request.referer) if request.referer
    end

    layout false

    def new
      redirect_to '/'
    end

    def create
      user = ::User.find_for_authentication(email: session_params[:email])
      if user && user.valid_password?(session_params[:password])
        if user.active_for_authentication?
          sign_in(user)
          session[:mindbox] = Mindbox::Operations.operation_parameters(:authorization_on_website, user: user).to_json
          render json: { location: after_sign_in_path_for_courses_shop(user) }
        else
          message = t('devise.failure.unconfirmed')
          render json: { errors: { email: [message] } }
        end
      else
        message = t('devise.failure.not_found_in_database')
        render json: { errors: { email: [message] } }
      end
    end

    def session_params
      params.require(:user).permit(:password, :email)
    end

    def destroy
      sign_out(:user)
      redirect_to after_sign_out_path_for_courses_shop(:user)
    end
  end
end