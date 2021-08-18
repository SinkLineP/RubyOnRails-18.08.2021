# Загрузка обложек материалов для чтения
# app/views/admin/blocks/templates/_material_form.erb
# @see app/assets/javascripts/admin/blocks/views/material_form.js.coffee
module Admin
  class MaterialCoversController < AdminController
    def create
      uploader = MaterialPreviewUploader.new
      uploader.cache! params[:file]
      render json: { preview_url: uploader.thumb.url, file_name: uploader.filename, cache: uploader.cache_name }
    rescue => ex
      render json: { error: upload_error(ex) }
    end
  end
end