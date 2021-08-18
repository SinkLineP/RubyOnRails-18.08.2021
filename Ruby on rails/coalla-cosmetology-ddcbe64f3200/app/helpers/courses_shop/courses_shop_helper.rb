module CoursesShop
  module CoursesShopHelper

    def shop_title
      I18n.t("shops.title.#{current_shop.code}") if current_shop
    end

    def registration_data
      @data ||= Registration::RegistrationData.new(session, :social_data)
    end

    def registration_user
      ::User.new(email: registration_data[:email],
                 first_name: registration_data[:first_name],
                 last_name: registration_data[:last_name])
    end

    def month_format(date)
      Russian.strftime(date, '%B %Y')
    end

    def button_class_for_shop
      current_shop.barbershop? ? 'button--barbershop' : 'button--institute'
    end

  end
end