# Контроллер раздела "Промокоды"
# @see app/views/admin/promo_codes
module Admin
  class PromoCodesController < AdminController
    authorize_resource

    before_action only: %i(edit update destroy) do
      @promo_code = PromoCode.find(params[:id])
    end

    def index
      @promo_codes = PromoCode.ordered.paginate(page: params[:page] || 1, per_page: PER_PAGE)
    end

    def new
      @promo_code = PromoCode.new
    end

    def create
      @promo_code = PromoCode.new(promo_code_params)
      if @promo_code.save
        redirect_to edit_admin_promo_code_path(@promo_code)
      else
        render :new
      end
    end

    def update
      @promo_code = PromoCode.find(params[:id])
      @promo_code.update(promo_code_params)
      render :edit
    end

    def destroy
      @promo_code.destroy
      redirect_to admin_promo_codes_path
    end

    protected

    def promo_code_params
      params.require(:promo_code).permit!.tap do |h|
        h[:course_ids] ||= []
      end
    end

  end
end