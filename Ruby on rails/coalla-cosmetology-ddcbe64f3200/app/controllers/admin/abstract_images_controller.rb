# Базовый контроллер
# для редактирования изображений института
# @see app/views/admin/abstract_images
module Admin
  class AbstractImagesController < AdminController

    before_action only: %i(edit update destroy) do
      @about_image = model.find(params[:id])
      force_update_current_shop_id(@about_image.shop_id)
    end

    set_current_shop_for_model(AboutImage)

    authorize_resource
    
    helper_method :model

    def index
      @about_images = model.ordered.paginate(page: params[:page] || 1, per_page: PER_PAGE)
    end

    def new
      @about_image = model.new
    end

    def create
      @about_image = model.new(about_image_params)
      if @about_image.save
        render :edit
      else
        render :new
      end
    end

    def update
      @about_image = model.find(params[:id])
      @about_image.update(about_image_params)
      render :edit
    end

    def destroy
      @about_image.destroy
      redirect_to redirect_url
    end

    protected

    def about_image_params
      params.require(:about_image).permit!
    end

    def model
    end

    def redirect_url
    end

  end
end