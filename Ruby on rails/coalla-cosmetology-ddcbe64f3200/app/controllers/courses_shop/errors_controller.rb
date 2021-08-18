module CoursesShop
  class ErrorsController < BaseController
    def show
      set_page_meta_tags(identifier: '/errors')
      @body_class = 'error-page'
      @code = (params[:code].presence || 500).to_i
      render layout: false, status: @code
    end
  end
end