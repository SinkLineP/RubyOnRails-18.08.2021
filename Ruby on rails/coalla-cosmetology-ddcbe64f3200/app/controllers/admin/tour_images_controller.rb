# Контроллер раздела "Экскурсия"
# @see AbstractImagesController
# @see app/views/admin/abstract_images
module Admin
  class TourImagesController < AbstractImagesController

    def model
      TourImage
    end

    def redirect_url
      admin_tour_images_path
    end

  end
end