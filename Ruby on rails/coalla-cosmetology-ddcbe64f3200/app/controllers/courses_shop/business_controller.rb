module CoursesShop
  class BusinessController < BaseController

    before_action do
      trigger_fb_event('fbViewContent')
    end

    before_action do
      set_page_meta_tags(identifier: '/business')
    end

    before_action except: :partners do
      @html = HtmlItem.find_by(page: action_name)
    end

    def consulting
      @services = Service.ordered
    end

    def partners
      @partners = Partner.ordered.paginate(page: (params[:page].presence || 1).to_i,
                                           per_page: PER_PAGE)

      set_meta_tags(canonical: courses_shop_partners_url) if params[:page].present?
      set_page_meta_tags title: 'Наши партнеры. Дом Русской Косметики'

      if request.xhr?
        render_ajax_collection(@partners, 'courses_shop/business/partner', '#partners_list', false, courses_shop_partners_url)
        return
      end
    end

    def regional_schools
      set_page_meta_tags title: 'Для региональных школ. Дом Русской Косметики'
    end

    def manufacturers_and_dealers
      set_page_meta_tags title: 'Производителям и дилерам. Дом Русской Косметики'
    end

    def mass_media
      set_page_meta_tags title: 'Для СМИ. Дом Русской Косметики'
    end

    def corporate_education
      set_page_meta_tags title: 'Корпоративное обучение. Дом Русской Косметики'
    end

    def recruitment
      set_page_meta_tags title: 'Подбор персонала. Дом Русской Косметики'
    end
  end
end