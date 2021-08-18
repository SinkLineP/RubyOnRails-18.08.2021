module CoursesShop
  class FaqsController < BaseController

    add_breadcrumb :faqs, :courses_shop_faqs_path

    before_action do
      trigger_fb_event('fbViewContent')
    end

    def index
      set_page_meta_tags(identifier: '/faqs')
      @faqs = Faq.ordered
    end

  end
end
