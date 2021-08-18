module CoursesShop
  class AboutController < BaseController

    layout false, only: :cecutient_version

    before_action do
      trigger_fb_event('fbViewContent')
    end

    TEACHERS_PER_PAGE = 6
    GRADUATES_PER_PAGE = 6

    before_action do
      set_page_meta_tags(identifier: '/about')
      title = "#{ty(t("about.#{action_name}"))}. Школа Светланы Сикорской"
      options = {site: ''}
      options[:title] = title if current_shop.barbershop?
      options[:og] = {title: title} if current_shop.barbershop?
      set_meta_tags(options)
    end

    before_action only: %i(history diploma cecutient_version) do
      @html = HtmlItem.find_by(page: action_name)
    end

    def history
      @history_events = HistoryEvent.ordered
      @reward_images = RewardImage.ordered
      set_page_meta_tags title: 'История института. Дом Русской Косметики'
    end

    def partners
      @partners = Partner.ordered.paginate(page: (params[:page].presence || 1).to_i,
                                           per_page: PER_PAGE)

      set_meta_tags(canonical: courses_shop_about_partners_url) if params[:page].present?
      set_page_meta_tags title: 'Партнеры. Дом Русской Косметики'

      if request.xhr?
        render_ajax_collection(@partners, 'courses_shop/business/partner', '#partners_list', false, courses_shop_about_partners_url)
        return
      end
    end

    def teachers
      @specialities = Speciality.root.alphabetical_order
      @current_speciality = Speciality.find_by(id: params[:speciality_id]) if params[:speciality_id]
      scope = Instructor.alphabetical_order
      scope = scope.with_speciality(@current_speciality) if @current_speciality
      @teachers = scope.paginate(page: (params[:page].presence || 1).to_i,
                                 per_page: TEACHERS_PER_PAGE)

      set_meta_tags(canonical: courses_shop_teachers_url) if params[:page].present?
      set_page_meta_tags title: 'Преподавательский состав. Дом Русской Косметики'

      if request.xhr?
        render_ajax_collection(@teachers, 'courses_shop/about/teacher', '#teachers_list', false, courses_shop_teachers_url)
        return
      end
    end

    def graduates
      @graduates = Graduate.ordered.paginate(page: (params[:page].presence || 1).to_i,
                                             per_page: GRADUATES_PER_PAGE)

      set_meta_tags(canonical: courses_shop_graduates_url) if params[:page].present?
      set_page_meta_tags title: 'Выпускники института. Дом Русской Косметики'

      if request.xhr?
        render_ajax_collection(@graduates, 'courses_shop/about/graduate', '#graduates_list', false, courses_shop_graduates_url)
        return
      end
    end

    def tour
      set_page_meta_tags title: 'Экскурсия по институту. Дом Русской Косметики'
      @tour_images = TourImage.ordered
    end

    def diploma
      set_page_meta_tags title: 'Международный диплом ITEC. Дом Русской Косметики'
    end

  end
end