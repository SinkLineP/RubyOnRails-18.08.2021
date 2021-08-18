class User::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    process_auth('Facebook')
  end

  private

  def process_auth(url_key = nil)
    return unless user_signed_in?

    auth_data = request.env['omniauth.auth']
    authentication = Authentication.find_by(provider: auth_data.provider, uid: auth_data.uid)

    if authentication
      flash[:profile_alert] = 'Под вашим аккаунтом был зарегистрирован другой пользователь. Возможно, вы сами создали несколько пользователей.' if authentication.user != current_user
      redirect_to edit_profile_path
    else
      current_user.authentications.create!(provider: auth_data.provider,
                                           access_token: auth_data.credentials.token,
                                           access_token_secret: auth_data.credentials.secret,
                                           url: auth_data.info.urls[url_key],
                                           uid: auth_data.uid)
      load_avatar(auth_data.info.image)
      redirect_to edit_profile_path
    end
  end

  def load_avatar(image_url)
    current_user.remote_avatar_url = image_url
    current_user.save!
  rescue => ex
    Rails.logger.error("Failed to load avatar, reason #{ex.message}")
  end
end