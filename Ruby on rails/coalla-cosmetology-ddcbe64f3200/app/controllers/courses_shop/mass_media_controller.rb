module CoursesShop
  class MassMediaController < ArticlesController
    add_breadcrumb :mass_media, :courses_shop_mass_media_section_index_path

    def index
      set_page_meta_tags(identifier: '/mass_media')
      scope = model.published.ordered_desc
      @items = scope.paginate(page: params[:page] || 1, per_page: PER_PAGE)

      set_meta_tags(canonical: courses_shop_mass_media_section_index_url) if params[:page].present?
      set_meta_page(params[:page])
      if request.xhr?
        render_ajax_collection(@items, 'courses_shop/articles/item', '#items_list', true, courses_shop_mass_media_section_index_url)
        return
      end
    end

    def model
      MassMedia
    end
  end
end
