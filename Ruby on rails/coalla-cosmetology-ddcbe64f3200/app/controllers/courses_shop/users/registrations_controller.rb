module CoursesShop
  class Users::RegistrationsController < Devise::RegistrationsController
    include RegistrationResource
    include ShopHelpers

    before_action do
      store_location_for(:user, request.referer) if request.referer
    end

    layout false

    def create
      @user = ::Student.new(sign_up_params)
      @user.source = current_shop.code
      password = Devise.friendly_token.first(8)
      @user.password = password
      if params[:social]
        @user.authentications.build(uid: data[:uid],
                                    provider: data[:provider],
                                    access_token: data[:access_token],
                                    access_token_secret: data[:access_token_secret],
                                    url: data[:url])
      end
      if @user.save
        sign_in(@user)
        @user.update_columns(welcome_sent_at: Time.current)
        unless params.require(:user)[:banner]
          #TODO(Vladimir Lelyakov): remove mail after integration
          if current_shop.cosmetic?
            Mindbox::XmlApiOperation.enqueue('FirstEmail',
                                             email: @user.email,
                                             password: @user.password)
          else
            CoursesShop::CoursesShopMailer.sign_in(@user).deliver!
          end
          Amocrm::Operations::CreateDefaultSubscription.new(roistat: cookies[:roistat_visit],
                                                            roistat_marker: cookies[:roistat_marker],
                                                            student: @user,
                                                            shop: current_shop)
            .perform
        end
        create_promo_code(@user, password)
        session.delete(:social_data)
        render json: {
          otherPopup: {
            name: '#popup-register-success',
            link: after_sign_in_path_for_courses_shop(:user)
          },
          mindbox: Mindbox::Operations.operation_parameters(:registration_on_website, user: @user),
          fbEvent: ('fbCompleteRegistration' if current_shop.barbershop?)
        }
      else
        render json: { errors: @user.errors }
      end
    end

    private

    def data
      @data ||= session.fetch(:social_data, {}).symbolize_keys
    end

    def sign_up_params
      params.require(:user).permit(:email, :first_name, :last_name, :subscribed_on_blog,
                                   user_phones_attributes: [:id, :number])
    end

    def create_promo_code(user, password)
      return unless params.require(:user)[:banner]
      discount_id = Discount.where(title: 'Регистрация на сайте через баннер').first.try(:id)
      return unless discount_id
      promo_code = PromoCode.new(code: PromoCode.generate_code, discount_id: discount_id)
      CoursesShop::CoursesShopMailer.notify_unisender_subscriber(user, promo_code, password).deliver if promo_code.save
    end

  end
end