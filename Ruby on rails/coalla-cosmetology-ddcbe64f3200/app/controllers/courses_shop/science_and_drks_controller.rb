module CoursesShop
  class ScienceAndDrksController < ArticlesController
    add_breadcrumb :science_and_drks, :courses_shop_science_and_drks_path

    def index
      set_page_meta_tags(identifier: '/science_and_drks')
      scope = model.published.ordered_desc
      @items = scope.paginate(page: params[:page] || 1, per_page: PER_PAGE)

      set_meta_tags(canonical: courses_shop_science_and_drks_url) if params[:page].present?
      set_meta_page(params[:page])

      if request.xhr?
        render_ajax_collection(@items, 'courses_shop/articles/item', '#items_list', true, courses_shop_science_and_drks_url)
        return
      end
    end

  end
end
