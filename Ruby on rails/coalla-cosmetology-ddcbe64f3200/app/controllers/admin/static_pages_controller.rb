# Контроллер раздела "Страницы"
# @see app/views/admin/static_pages
module Admin
  class StaticPagesController < AdminController
    before_filter :store_path_history

    load_and_authorize_resource

    def index
      @static_pages = StaticPage.ordered.paginate(page: params[:page] || 1, per_page: PER_PAGE)
    end

    def new; end

    def create
      @static_page.assign_attributes(static_page_params)
      params[:preview] ? preview : save
    end

    def edit; end

    def update
      @static_page.assign_attributes(static_page_params)
      params[:preview] ? preview : save
    end

    private

    def save
      if @static_page.save
        redirect_to_back
      else
        render @static_page.new_record? ? 'new' : 'edit'
      end
    end

    def preview
      render :preview, layout: 'application'
    end

    def static_page_params
      params.require(:static_page).permit!
    end
  end
end