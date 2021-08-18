module CoursesShop
  class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    include RegistrationResource
    include ShopHelpers

    before_action before: :passthru do
      store_location_for(:user, request.referer) if request.referer
    end

    def failure
      logger.error "Failed to login via social network, reason #{failure_message}"
      super
    end

    def facebook
      process_auth('facebook')
    end

    def vkontakte
      process_auth('vkontakte')
    end

    def odnoklassniki
      process_auth('odnoklassniki', avatar: ->(omniauth) { omniauth.extra.raw_info.pic_2 })
    end

    private

    def process_auth(provider, options = {})
      omniauth = request.env['omniauth.auth']
      uid = omniauth.uid
      authentication = Authentication.find_by(provider: provider, uid: uid)

      if user_signed_in?
        unless authentication
          current_user.authentications.create!(provider: omniauth.provider,
                                               access_token: omniauth.credentials.token,
                                               access_token_secret: omniauth.credentials.secret,
                                               url: omniauth.info.urls.try(:[], omniauth.provider.to_s.capitalize),
                                               uid: omniauth.uid)
        end
        redirect_to request.env['omniauth.origin'].presence || after_sign_in_path_for_courses_shop(current_user)
      else
        if authentication
          authentication.update(access_token: omniauth.credentials.token, access_token_secret: omniauth.credentials.secret)
          sign_in(authentication.user)
          session[:mindbox] = Mindbox::Operations.operation_parameters(:authorization_on_website, user: authentication.user).to_json
          redirect_to after_sign_in_path_for_courses_shop(authentication.user)
        else
          processor = Registration::SocialDataProcessor.new(provider, options)
          session[:social_data] = processor.process(omniauth, request.env['omniauth.params'])
          redirect_to courses_shop_root_url(continue_registration: true)
        end
      end
    end

    def after_omniauth_failure_path_for(scope)
      courses_shop_root_url
    end

  end
end