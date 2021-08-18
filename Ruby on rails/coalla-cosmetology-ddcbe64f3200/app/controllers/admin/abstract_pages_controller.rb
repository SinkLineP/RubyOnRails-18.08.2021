# Базовый контроллер
# для редактирования страниц об институтах
# @see app/views/admin/abstract_pages
module Admin
  class AbstractPagesController < AdminController
    before_action only: [:edit, :update] do
      @html_item = HtmlItem.send(scope_name).find(params[:id])
      force_update_current_shop_id(@html_item.shop_id)
      authorize! :edit, @html_item
    end

    set_current_shop_for_model(HtmlItem)

    helper_method :scope_name, :redirect_url

    def index
      authorize! :read, HtmlItem
      @html_items = HtmlItem.send(scope_name)
    end

    def edit
    end

    def update
      if @html_item.update(params.require(:html_item).permit!)
        redirect_to redirect_url
      else
        render :edit
      end
    end

    def scope_name
    end

    def redirect_url
    end
  end
end