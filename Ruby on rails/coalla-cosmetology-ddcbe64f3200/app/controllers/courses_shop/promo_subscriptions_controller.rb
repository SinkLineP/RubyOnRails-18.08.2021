module CoursesShop
  class PromoSubscriptionsController < BaseController
    include AjaxRequestsOnly
    include PopupTexts

    layout false

    before_action :ajax_requests_only

    def create
      form_data = PromoSubscription.new(params[:promo_subscription].permit!)
      if form_data.email_exist.present?
        cookies[:course_id] = form_data.course_id
        render json: {
            otherPopup: { name: '#popup-login', link: '#', email: form_data.email }
        }
        return
      end

      if form_data.invalid? || generate_user(form_data).blank?
        render json: { errors: form_data.errors }
        return
      end

      cookies[:course_id] = form_data.course_id
      respond_to do |format|
        format.js { render inline: "location.reload();" }
      end
    end

    private

    def generate_user(form_data)
      last_name = form_data.last_name.presence || form_data.email
      user = Student.new(email: form_data.email, last_name: last_name)
      user.add_phone(form_data.phone_number)
      user.source = current_shop.code
      password = Devise.friendly_token.first(8)
      user.password = password
      return unless user.save

      sign_in(user)
      user.update_columns(welcome_sent_at: Time.current)
      if current_shop.cosmetic?
        Mindbox::XmlApiOperation.enqueue('FirstEmail', email: user.email, password: user.password)
      else
        CoursesShop::CoursesShopMailer.sign_in(user).deliver!
      end
      Amocrm::Operations::CreateDefaultSubscription.new(roistat: cookies[:roistat_visit], roistat_marker: cookies[:roistat_marker], student: user, shop: current_shop).perform
      user
    end

    def permitted_params
      params[:promo_subscription].(:course_id, :is_blog, :email, :phone_number, :last_name)
    end

    def redirect_to_default
      redirect_to root_path
    end
  end
end
