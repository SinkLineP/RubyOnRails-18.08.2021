# Контроллер раздела "Баннеры"
# @see app/views/admin/banners
module Admin
  class BannersController < AdminController
    before_action only: %i(edit update destroy) do
      @banner = Banner.find(params[:id])
      force_update_current_shop_id(@banner.shop_id)
    end

    set_current_shop_for_model(Banner)

    authorize_resource

    def index
      @banners = Banner.ordered
    end

    def new
      @banner = Banner.new
    end

    def create
      @banner = Banner.new(banner_params)
      if @banner.save
        redirect_to edit_admin_banner_path(@banner)
      else
        render :new
      end
    end

    def edit; end

    def update
      @banner.update(banner_params)
      render :edit
    end

    def destroy
      @banner.destroy
      redirect_to action: :index
    end

    private

    def banner_params
      params.require(:banner).permit!
    end
  end
end