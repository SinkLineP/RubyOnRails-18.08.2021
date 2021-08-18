module CoursesShop
  module PromotionsHelper

    def promotions_url_with_marks(url)
      markers = utm_markers.load
      ::UrlUtils.add_params(url, markers)
    end

  end
end