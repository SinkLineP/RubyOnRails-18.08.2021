# Загрузка изображений
# @see app/assets/javascripts/admin/articles.js.coffee
# @see app/assets/javascripts/admin/images.js.coffee
module Admin
  class ImagesController < AdminController
    before_action do
      authorize! :load, :post_image
    end

    def create
      image = params[:uploader].constantize.new
      image.cache!(params[:image])
      render json: { imageUrl: image.url(params[:version]), imageCache: image.cache_name }
    rescue => ex
      render json: { error: ex.message }
    end
  end
end