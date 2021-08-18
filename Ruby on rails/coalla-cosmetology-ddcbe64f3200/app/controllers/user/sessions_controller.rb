class User::SessionsController < Devise::SessionsController
  include Devise::Controllers::Rememberable

  def new
    if user_signed_in?
      redirect_to after_sign_in_path_for(current_user)
      return
    end

    @user = User.new
    if !set_share_meta_tags
      set_meta_tags og: {
        title: 'Дом Русской Косметики',
        description: 'Sikorsky Beauty Academy'
      }
    end
  end

  def create
    user_params = params.require(:user).permit(:email, :password)
    user = User.find_for_authentication(email: user_params[:email])
    if user && user.valid_password?(user_params[:password])
      sign_in(user)
      remember_me(user)
      render json: { path: after_sign_in_path_for(user) }
    else
      render json: { error: t('devise.failure.not_found_in_database') }
    end
  end

end
