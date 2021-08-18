class User::PasswordsController < Devise::PasswordsController
  before_action do
    redirect_to(root_path) unless request.xhr?
  end

  layout false

  def create
    user, errors = load_user

    if errors.present?
      render json: {errors: errors}
    else
      new_password = Devise.friendly_token(8)
      user.update!(password: new_password)
      CosmetologyMailer.new_password(user).deliver
      render json: {success: render_to_string(:success)}
    end
  end

  def edit
    render code: 404
  end

  def update
    render code: 404
  end

  private

  def email
    params[:user][:email].to_s.downcase
  end

  def load_user
    return nil, {email: 'должна быть указана'} if email.blank?

    user = User.find_by(email: email)

    return nil, {email: 'не удалось найти аккаунт'} if user.blank?

    return user, {}
  end

end