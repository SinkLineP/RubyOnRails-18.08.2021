module CoursesShop
  class RecallsController < BaseController
    add_breadcrumb :recalls, :courses_shop_recalls_path

    before_action do
      trigger_fb_event('fbViewContent')
    end

    def index
      set_page_meta_tags(identifier: '/recalls')
      scope = Recall.ordered_desc
      direction = params[:direction].presence_in(Recall.directions.values)
      if direction
        @direction_text = Recall.directions.find_value(direction).text
        scope = scope.with_direction(direction)
      end
      @recalls = scope.paginate(page: params[:page] || 1, per_page: PER_PAGE)

      set_meta_tags(canonical: courses_shop_recalls_url) if params[:page].present?
      set_meta_page(params[:page])
      if request.xhr?
        render_ajax_collection(@recalls, 'courses_shop/recalls/recall', '#recalls_list', true, courses_shop_recalls_url)
        return
      end
    end
  end
end
