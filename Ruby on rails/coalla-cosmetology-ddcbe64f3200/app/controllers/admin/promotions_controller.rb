# Контроллер раздела "Акции"
# @see app/views/admin/promotions
module Admin
  class PromotionsController < AdminController
    before_action only: %i(edit update destroy) do
      @promotion = Promotion.find(params[:id])
      force_update_current_shop_id(@promotion.shop_id)
    end

    authorize_resource

    set_current_shop_for_model(Promotion)

    def index
      @promotions = Promotion.ordered.paginate(page: params[:page] || 1, per_page: PER_PAGE)
    end

    def new
      @promotion = Promotion.new
    end

    def create
      @promotion = Promotion.new(promotion_params)
      if @promotion.save
        redirect_to edit_admin_promotion_path(@promotion)
      else
        render :new
      end
    end

    def update
      @promotion = Promotion.find(params[:id])
      @promotion.update(promotion_params)
      render :edit
    end

    def destroy
      @promotion.destroy
      redirect_to admin_promotions_path
    end

    protected

    def promotion_params
      params.require(:promotion).permit!
    end

  end
end