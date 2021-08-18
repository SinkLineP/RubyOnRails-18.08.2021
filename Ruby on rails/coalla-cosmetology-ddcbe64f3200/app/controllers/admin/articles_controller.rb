# Контроллер раздела "Блог, Мы и СМИ, Наука и ДРК"
# @see app/views/admin/articles
module Admin
  class ArticlesController < AdminController
    before_action except: %i(index new create list blog_list) do
      @article = Article.find(params[:id])
      force_update_current_shop_id(@article.shop_id)
    end

    set_current_shop_for_model(Article)
    set_current_shop_for_model(BlogCategory)
    set_current_shop_for_model(Category)

    authorize_resource

    helper_method :root_specialities

    def index
      @q = Article.ransack(params[:q])
      @articles = @q.result.ordered.paginate(page: params[:page] || 1, per_page: PER_PAGE)
    end

    def new
      @article = Article.new(type: params[:type])
    end

    def create
      @article = Article.new(article_params)
      save_and_response
    end

    def root_specialities
      @root_specialities ||= Speciality.root.ordered
    end

    def show
      @preview_from_admin = true
      render 'courses_shop/articles/show', layout: 'courses_shop/base', locals: { article: @article }
    end

    def update
      @article.assign_attributes(article_params)
      save_and_response
    end

    def destroy
      @article.destroy
      redirect_to action: :index
    end

    def toggle_field
      @article.toggle!(params[:field])
      redirect_to action: :index
    end

    def notify
      MailChimpService.new(@article, view_context).notify!
      render nothing: true
    end

    def list
      articles = Article.ordered
      articles = articles.where(type: params[:type]) if params[:type]
      articles = articles.where('title ilike ?', "%#{params[:term]}%") if params[:term].present?
      render json: articles.first(LIST_SIZE).map { |article| { value: article.title, id: article.id, link: edit_admin_article_path(article) } }
    end

    def blog_list
      articles = Blog.ordered
      articles = articles.where('title ilike ?', "%#{params[:term]}%") if params[:term].present?
      render json: articles.first(LIST_SIZE).map { |article| {value: article.title, id: article.id} }
    end

    private

    def article_params
      params.require(:article).permit!.tap do |h|
        %i(similars_ids courses_ids).each do |name|
          if h[name].blank? && h['type'] == 'MassMedia'
            h.delete(name)
          else
            h[name] ||= []
          end
        end
      end
    end

    def save_and_response
      if @article.save
        redirect_to edit_admin_article_path(@article)
      else
        render :edit
      end
    end
  end
end