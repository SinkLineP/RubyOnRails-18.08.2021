# Контроллер раздела "Выпускники"
# @see app/views/admin/graduates
module Admin
  class GraduatesController < Admin::AdminController
    before_action only: %i(edit update destroy) do
      @graduate = Graduate.find(params[:id])
      force_update_current_shop_id(@graduate.shop_id)
    end

    authorize_resource

    set_current_shop_for_model(Graduate)
    set_current_shop_for_model(Faculty)

    def index
      @graduates = Graduate.ordered.paginate(page: params[:page] || 1, per_page: PER_PAGE)
    end

    def new
      @graduate = Graduate.new
    end

    def create
      @graduate = Graduate.new(graduate_params)
      if @graduate.save
        redirect_to edit_admin_graduate_path(@graduate)
      else
        render :new
      end
    end

    def update
      @graduate = Graduate.find(params[:id])
      @graduate.update(graduate_params)
      render :edit
    end

    def destroy
      @graduate.destroy
      redirect_to admin_graduates_path
    end

    protected

    def graduate_params
      params.require(:graduate).permit!
    end
  end
end