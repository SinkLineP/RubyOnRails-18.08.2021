module CoursesShop
  class HomeController < BaseController

    before_action do
      trigger_fb_event('fbViewContent')
    end

    def index
      set_page_meta_tags(identifier: :default)
      @recalls = Recall.for_main.ordered
      @partners = Partner.ordered
      @our_advantages = Lookup.our_advantages.ordered
      @blogs = Blog.published.for_main.ordered_by_change_desc.first(6)
      @about = HtmlItem.home_about(current_shop.id)
      @instructors = Instructor.home_page
      respond_to do |format|
        format.html
      end
    end

    def contacts
      add_breadcrumb :contacts, :courses_shop_contacts_path
      set_page_meta_tags(identifier: '/contacts')
    end

    def offer
      add_breadcrumb :offer, :courses_shop_offer_path
      @html_items = HtmlItem.offer
      set_page_meta_tags title: 'Оферта и условия использования. Дом Русской Косметики'
    end

    def license
      add_breadcrumb :license, :courses_shop_license_path
      set_page_meta_tags(identifier: '/license')
    end

    def promotions
      add_breadcrumb :promotions, :courses_shop_promotions_path
      set_page_meta_tags(identifier: '/promotions')
      @promotions = Promotion.visible.ordered_desc
    end

    def models
      add_breadcrumb :models, :courses_shop_models_path
      set_page_meta_tags(identifier: '/models')
      @cosmetology_procedures = CosmetologyProcedure.ordered
    end

    def privacy_policy
      @html_item = HtmlItem.privacy_policy.first
      set_page_meta_tags title: 'Защита персональных данных. Дом Русской Косметики'
    end

    def cookies_policy
      add_breadcrumb :cookies_policy
    end

  end
end
