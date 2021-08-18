# Контроллер раздела "Партнеры"
# @see app/views/admin/partners
module Admin
  class PartnersController < AdminController
    load_and_authorize_resource

    before_action only: [:edit, :update, :destroy] do
      force_update_current_shop_id(@partner.shop_id)
    end

    set_current_shop_for_model(Partner)

    before_action :store_path_history

    def index
      @partners = Partner.ordered.paginate(page: params[:page] || 1,
                                           per_page: PER_PAGE)
    end

    def create
      if @partner.save
        redirect_to last_uri
      else
        render :new
      end
    end

    def update
      @partner.assign_attributes(partner_params)
      if @partner.save
        redirect_to last_uri
      else
        render :edit
      end
    end

    def destroy
      @partner.destroy
      redirect_to last_uri
    end

    private

    def partner_params
      params.require(:partner).permit!
    end

  end
end