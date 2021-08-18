# Контроллер раздела "Автоматические скидки"
# @see app/views/admin/automatic_discounts
module Admin
  class AutomaticDiscountsController < AdminController
    authorize_resource

    before_action only: %i(edit update destroy) do
      @automatic_discount = AutomaticDiscount.find(params[:id])
    end

    def index
      @automatic_discounts = AutomaticDiscount.ordered.paginate(page: params[:page] || 1, per_page: PER_PAGE)
    end

    def new
      @automatic_discount = AutomaticDiscount.new
    end

    def create
      @automatic_discount = AutomaticDiscount.new(automatic_discount_params)
      if @automatic_discount.save
        redirect_to edit_admin_automatic_discount_path(@automatic_discount)
      else
        render :new
      end
    end

    def update
      @automatic_discount = AutomaticDiscount.find(params[:id])
      @automatic_discount.update(automatic_discount_params)
      render :edit
    end

    def destroy
      @automatic_discount.destroy
      redirect_to admin_automatic_discounts_path
    end

    protected

    def automatic_discount_params
      params.require(:automatic_discount).permit!.tap do |h|
        h[:course_ids] ||= []
      end
    end

  end
end