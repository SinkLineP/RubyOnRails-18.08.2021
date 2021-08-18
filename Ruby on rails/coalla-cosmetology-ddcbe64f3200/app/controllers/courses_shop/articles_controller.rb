module CoursesShop
  class ArticlesController < BaseController

    before_action do
      trigger_fb_event('fbViewContent')
    end

    helper_method :model

    PER_PAGE = 9

    def index
      set_page_meta_tags(identifier: '/articles')
      scope = model.published.ordered_desc
      @items = scope.paginate(page: params[:page] || 1, per_page: PER_PAGE)

      if request.xhr?
        render_ajax_collection(@items, 'courses_shop/articles/item', '#items_list')
        return
      end
    end

    def show
      @article = model.find(params[:id])
      set_meta_tags_for_item(@article, @article.preview_image_url(:main))
      add_breadcrumb @article.title
    end

    def model
      controller_name.singularize.camelize.constantize
    end
  end
end
