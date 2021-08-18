module CoursesShop
  class BaseController < ActionController::Base
    include Coalla::HttpAuth
    include TypographHelper
    include PageMetaTags
    include ShopHelpers

    before_action :unset_current_shop
    before_action :set_current_shop
    after_action :unset_current_shop

    rescue_from Exception do |exception|
      unset_current_shop
      raise exception
    end

    PER_PAGE = 10

    layout 'courses_shop/base'

    delegate :save, to: :utm_markers, prefix: true

    before_action :utm_markers_save
    before_action :basic_authenticate
    before_action :add_root_breadcrumbs

    helper_method :root_specialities, :root_specialities_for_main, :mobile?, :utm_markers, :current_shop

    unless Rails.env.development?
      rescue_from ActionController::UnknownFormat do
        redirect_to '/404'
      end
    end

    def root_specialities
      @root_specialities ||= Speciality.root.level.ordered
    end

    def root_specialities_for_main
      @root_specialities_for_main ||= Speciality.for_main.root.level.ordered
    end

    def render_ajax_collection(items, partial, append_to, pages = true, canonical_url = nil)
      items_html = render_to_string(partial: partial, collection: items).html_safe
      pagination_complex = render_to_string(partial: 'courses_shop/common/pagination_complex',
                                            locals: { items: items, append_to: append_to, pages: pages })
      render json: {
        items: items_html,
        paginationComplex: pagination_complex,
        location: request.fullpath,
        canonicalUrl: canonical_url
      }
    end

    def mobile?
      @browser ||= Browser.new(request.user_agent)
      @browser.device.mobile?
    end

    def authenticate_user!
      user = super
      return user if user.is_a?(Student)
      redirect_to courses_shop_root_path
    end

    def current_user
      user = super
      user if user.is_a?(Student)
    end

    def user_signed_in?
      signed_in = super
      signed_in && current_user
    end

    def trigger_fb_event(event_name)
      session[:fb_event] = event_name
    end

    def set_meta_page(page)
      title = @meta_tags['title']
      description = @meta_tags['description']
      if page.present?
        title = "#{title} - Страница #{page}"
        description = "#{description} Страница #{page}"
      end
      set_meta_tags(title: title, description: description)
    end

    def add_root_breadcrumbs
      add_breadcrumb I18n.t("shops.title.#{current_shop.code}"), :root_path
    end

    protected

    def utm_markers
      @utm_markers ||= Promotions::UtmMarkers.new(request.query_parameters, cookies)
    end

  end
end
