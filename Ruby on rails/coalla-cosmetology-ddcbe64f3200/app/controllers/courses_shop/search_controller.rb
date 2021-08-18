module CoursesShop
  class SearchController < BaseController
    before_action do
      trigger_fb_event('fbSearch')
    end

    def show
      ids = Course.joins(:course_specialities).includes(:nearest_group).displayed.pluck(:id).uniq.reject(&:blank?)
      @courses = ThinkingSphinx.search(s_find_escape,
                                       with: { id_number: ids, shop_id: [current_shop.id, 0] },
                                       page: (params[:page].presence || 1).to_i,
                                       per_page: PER_PAGE, classes: [Course])


      if request.xhr?
        if @current_shop.barbershop?
          render_ajax_collection(@courses, 'courses_shop/courses/course_li',
                                 '#courses_list', false)
        else
          render_ajax_collection(@courses, 'courses_shop/courses/course_li_grid',
                                 '#courses_list_grid', false)
        end
        return
      end
    end

    private

    def s_find_escape
      "*#{Riddle::Query.escape(params[:q].to_s)}*"
    end
  end
end