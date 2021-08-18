module CoursesShop
  class ProfilesController < BaseController
    before_action :authenticate_user!

    before_action do
      @user = User.find(current_user.id)
      @user.user_phones.build unless @user.user_phones.present?
    end

    def edit; end

    def update
      if update_user
        UnisenderService.new(@user.email, self).subscribe! if @user.subscribed_on_blog?
        render json: { location: edit_courses_shop_profile_path, mindbox: mindbox_parameters(@user) }
      else
        render json: { errors: @user.errors }
      end
    end

    private

    def update_user
      if change_password?
        @user.validate_password = true
        saved = @user.update_with_password(profile_params)
        sign_in(@user, bypass: true) if saved
        saved
      else
        clear_password_params
        @user.update_without_password(profile_params)
      end
    end

    PASSWORD_PARAMS = [:password, :current_password]

    def change_password?
      PASSWORD_PARAMS.any? { |field| profile_params[field].present? }
    end

    def clear_password_params
      PASSWORD_PARAMS.each { |param| profile_params.delete(param) }
    end

    def profile_params
      @profile_params ||= params.require(:user).permit(:email, :password, :current_password,
                                                       :first_name, :last_name, :middle_name,
                                                       :subscribed_on_blog,
                                                       user_phones_attributes: [:id, :number, :_destroy])
    end

    def mindbox_parameters(user)
      Mindbox::Operations.operation_parameters(:edit_user_data, user: user)
    end

  end
end