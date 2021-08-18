module CoursesShop
  class HairdressersController < BaseController
    layout 'layouts/sikorsky_school/hairdressers'

    def show
      unless current_shop.barbershop?
        raise ActionController::RoutingError.new('Not Found')
      end
    end
  end
end