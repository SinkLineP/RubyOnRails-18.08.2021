module CoursesShop
  class UnisenderController < BaseController

    def subscribe
      email = params[:email].to_s.squish.strip.downcase

      if email.blank? || !(email =~ Devise.email_regexp)
        render json: { errors: { email: ['Введите email в корректном формате'] } }
        return
      end

      UnisenderService.new(email, self).subscribe!
      user = User.find_by(email: email)
      user.update_column(:subscribed_on_blog, true) if user
      render json: {
        location: courses_shop_blogs_path(show_popup: true),
        mindbox: mindbox_parameters(email),
        dataLayer: { event: 'subscribeform' }
      }
    end

    private

    def mindbox_parameters(email)
      Mindbox::Operations.operation_parameters(:podpiska_v_forme,
                                               subscriber: OpenStruct.new(email: email))
    end

  end
end
