class BlogSubscribersController < ApplicationController
  def create
    if user_signed_in?
      BlogSubscriber.create!(user: current_user)
      render json: {message: 'Спасибо, что подписались на ежедневную рассылку'}
      return
    end

    email = params[:email].to_s.squish.strip.downcase

    if email.blank? || !(email =~ Devise.email_regexp)
      render json: {error: 'Введите email в корректном формате'}
      return
    end

    subscriber = BlogSubscriber.find_by(email: email)
    if subscriber.present?
      session[:has_blog_subscription] = true
      render json: {message: 'Вы уже подписаны на ежедневную рассылку'}
      return
    end

    user = User.find_by(email: email)
    attrs = user.present? ? {user: user} : {email: email}
    BlogSubscriber.create!(attrs)
    session[:has_blog_subscription] = true
    render json: {message: 'Спасибо, что подписались на ежедневную рассылку'}
  end


end