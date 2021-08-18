module CoursesShop
  class BlogsController < BaseController
    include FirstPageRedirectable
    add_breadcrumb :blogs, :courses_shop_blogs_path

    before_action do
      trigger_fb_event('fbViewContent')
    end

    PER_PAGE = 9
    PER_PAGE_INNER = 3

    def index
      set_page_meta_tags(identifier: '/articles')
      @categories = Category.ordered.map{|ctg| [ctg.name, ctg.id]}
      @dates = Blog.dates

      @current_category = Category.find_by(id: params[:blog_category_id])
      @current_date = params[:date].to_date if params[:date]
      scope = Blog.published.ordered_desc
      scope = scope.by_date_range(@current_date.beginning_of_month, @current_date.end_of_month) if @current_date
      scope = scope.with_category(@current_category.id) if @current_category
      page = params[:page] || 1
      set_meta_page(params[:page])
      @blogs = scope.paginate(page: page, per_page: PER_PAGE)
      set_meta_tags(canonical: courses_shop_blogs_url) if params[:page].present?

      if request.xhr?
        render_ajax_collection(@blogs, 'courses_shop/blogs/blog', '#blogs_list', true, courses_shop_blogs_url)
        return
      end
    end

    def show
      @article = Blog.find(params[:id])
      @blog_banner = @article.square_banners.active.ordered.first
      @special_offers = @article.courses.active
      @blogs = @article.similars.paginate(page: params[:page] || 1, per_page: PER_PAGE_INNER)
      if request.xhr?
        render_ajax_collection(@blogs, 'courses_shop/blogs/blog', '#blogs_list', false, courses_shop_blog_url(@article))
        return
      end
      set_meta_tags_for_item(@article, @article.preview_image_url(:main))
      add_breadcrumb @article.title
      render 'courses_shop/articles/show'
    end
  end
end
