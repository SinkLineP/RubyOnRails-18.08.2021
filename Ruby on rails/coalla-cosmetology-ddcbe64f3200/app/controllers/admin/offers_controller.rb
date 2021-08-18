# Контроллер раздела "Оферта"
# @see app/views/admin/offers
module Admin
  class OffersController < AdminController
    before_action only: [:edit, :update] do
      @html_item = HtmlItem.offer.find(params[:id])
      force_update_current_shop_id(@html_item.shop_id)
      authorize! :edit, @html_item
    end

    set_current_shop_for_model(HtmlItem)

    def index
      authorize! :read, HtmlItem
      @html_items = HtmlItem.offer
    end

    def update
      if @html_item.update(params.require(:html_item).permit!)
        redirect_to admin_offers_path
      else
        render :edit
      end
    end
  end
end