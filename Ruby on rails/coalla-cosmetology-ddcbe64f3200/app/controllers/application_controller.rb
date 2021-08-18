class ApplicationController < ActionController::Base
  include Share
  include TypographHelper

  before_action :unset_current_shop
  after_action :unset_current_shop

  layout :select_layout
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Exception do |exception|
    unset_current_shop
    if exception.is_a?(CanCan::AccessDenied)
      redirect_to new_user_session_path, alert: exception.message
    else
      raise exception
    end
  end

  before_action :load_last_letter, unless: :devise_controller?

  helper_method :current_shop

  def after_sign_in_path_for_courses_shop(resource)
    [
      stored_location_for(resource),
      request.referer,
      courses_shop_root_url
    ].reject(&:blank?).first
  end

  def after_sign_out_path_for_courses_shop(resource)
    after_sign_in_path_for_courses_shop(resource)
  end

  def after_sign_in_path_for(user)
    if user.admin?
      admin_courses_url
    elsif user.instructor?
      admin_my_students_url
    elsif user.manager?
      admin_students_url
    elsif !user.can_sign_in? && Shop.find_by_request(request)
      edit_profile_path
    else
      user.hide_tutorial? ? progress_url : tutorial_url
    end
  end

  def real_csrf_token(session)
    token = super
    Rails.logger.info("Request token for user with session #{session.id} -> #{token}")
    token
  end

  def compare_with_real_token(token, session)
    Rails.logger.info("Compare tokens: #{token}, #{real_csrf_token(session)}")
    super
  end

  protected

  def namespace
    controller_name_segments = params[:controller].split('/')
    controller_name_segments.pop
    controller_name_segments.join('/').camelize
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, namespace)
  end


  def dashboard_mode
    @dashboard = true
  end

  def set_title(title)
    @page_title = title
  end

  def select_layout
    if user_signed_in?
      if current_user.admin? || current_user.instructor? || current_user.manager?
        'admin'
      else
        'user'
      end
    else
      'application'
    end
  end

  def load_last_letter
    return if current_user.blank? || !current_user.student? || %w(tasks results).include?(controller_name)
    @new_letter = current_user.letters.unread.ordered.first
    current_user.letters.unread.update_all(read: true) if @new_letter.present?
  end

  def current_shop
    @current_shop ||= find_shop(session[:shop_id])
  end

  def force_update_current_shop_id(shop_id)
    return unless shop_id
    session[:shop_id] = shop_id
    @current_shop = find_shop(shop_id)
  end

  def update_current_shop_id
    return if params[:shop_id].blank?
    session[:shop_id] = find_shop(params[:shop_id]).id
    redirect_to after_shop_update_path
  end

  def unset_current_shop
    SharedModels.unset_current_shop
  end

  def set_current_shop
    return unless current_shop
    SharedModels.set_current_shop(current_shop.id)
    @shop_dependent_controller = true
  end

  def set_current_shop_for_model(model)
    return unless current_shop
    SharedModels.set_current_shop_for_model(model, current_shop.id)
    @shop_dependent_controller = true
  end

  def find_shop(id)
    Shop.find_by(id: id) || Shop.default_shop
  end

  def after_shop_update_path
    action = respond_to?(:index) ? :index : :edit
    url_for(action: action)
  end
end
