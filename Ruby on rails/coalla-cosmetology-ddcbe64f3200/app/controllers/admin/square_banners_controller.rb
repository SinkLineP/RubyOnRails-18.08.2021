# Контроллер раздела "Баннеры для постов блога"
# @see app/views/admin/square_banners
module Admin
  class SquareBannersController < AdminController
    before_action only: %i(edit update destroy) do
      @square_banner = SquareBanner.find(params[:id])
      force_update_current_shop_id(@square_banner.shop_id)
    end

    set_current_shop_for_model(SquareBanner)

    authorize_resource

    before_action only: %i(new create) do
      @square_banner = SquareBanner.new
    end

    def index
      @square_banners = SquareBanner.ordered
    end

    def new; end

    def create
      @square_banner.assign_attributes(square_banner_params)
      save_and_response
    end

    def edit; end

    def update
      @square_banner.assign_attributes(square_banner_params)
      save_and_response
    end

    def destroy
      @square_banner.destroy
      redirect_to action: :index
    end

    protected

    def save_and_response(options = {})
      if @square_banner.save
        redirect_to edit_admin_square_banner_path(@square_banner)
      else
        render :edit
      end
    end

    private

    def square_banner_params
      result = params.require(:square_banner).permit(:active,
                                                     :desktop_text,
                                                     :mobile_text,
                                                     :image_cache,
                                                     :mobile_image_cache,
                                                     :btn_title,
                                                     :link,
                                                     article_ids: []).tap do |h|
        %i(article_ids).each do |name|
          h[name] ||= []
        end
      end
      result
    end
  end
end