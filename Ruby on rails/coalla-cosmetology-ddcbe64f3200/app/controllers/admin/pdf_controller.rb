# Загрузка PDF
# @see app/assets/javascripts/admin/book_forms.coffee
# @see app/assets/javascripts/admin/tutorial.js.coffee
# @see app/assets/javascripts/admin/vacancy_groups.js.coffee
# @see app/assets/javascripts/admin/blocks/views/lecture_body.js.coffee
# @see app/assets/javascripts/admin/blocks/views/material_form.js.coffee
module Admin
  class PdfController < AdminController
    def create
      uploader = PdfUploader.new
      uploader.cache! params[:file]
      render json: { filename: uploader.filename, extension: uploader.file.extension.upcase, cache: uploader.cache_name }
    rescue => ex
      render json: { error: upload_error(ex) }
    end
  end
end