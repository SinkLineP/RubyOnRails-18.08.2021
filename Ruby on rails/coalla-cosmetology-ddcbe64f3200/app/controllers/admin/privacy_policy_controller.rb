# Контроллер раздела "Политика использования персональных данных"
# @see app/views/admin/offers
module Admin
  class PrivacyPolicyController < AdminController
    before_action only: [:edit, :update] do
      @html_item = HtmlItem.privacy_policy.find(params[:id])
      force_update_current_shop_id(@html_item.shop_id)
      authorize! :edit, @html_item
    end

    set_current_shop_for_model(HtmlItem)

    def index
      authorize! :read, HtmlItem
      @html_items = HtmlItem.privacy_policy
    end

    def update
      if @html_item.update(params.require(:html_item).permit!)
        redirect_to admin_privacy_policy_index_path
      else
        render :edit
      end
    end
  end
end