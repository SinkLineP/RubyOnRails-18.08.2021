module CoursesShop
  class BarbersController < BaseController
    layout 'layouts/sikorsky_school/barbers'

    def show
      unless current_shop.barbershop?
        raise ActionController::RoutingError.new('Not Found')
      end
    end
  end
end