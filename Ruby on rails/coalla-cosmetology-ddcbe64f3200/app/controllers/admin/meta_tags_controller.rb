# Контроллер раздела "Мета-теги"
# @see app/views/admin/meta_tags
module Admin
  class MetaTagsController < AdminController
    before_action only: %i(edit update) do
      @site_meta_tag = SiteMetaTags.find(params[:id])
      force_update_current_shop_id(@site_meta_tag.shop_id)
    end

    set_current_shop_for_model(SiteMetaTags)

    def index
      @site_meta_tags = SiteMetaTags.ordered.paginate(page: params[:page] || 1, per_page: PER_PAGE)
    end

    def update
      @site_meta_tag.update(meta_tag_params)
      render :edit
    end

    protected

    def meta_tag_params
      params.require(:meta_tag).permit!
    end
  end
end