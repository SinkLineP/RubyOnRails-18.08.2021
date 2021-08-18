module CoursesShop
  class NewBasesController < BaseController
    layout 'layouts/courses_shop/new_base'

    def show
    end

    def promo1
      @partners = Partner.ordered
    end

    def promo2
    end

    def promo3
    end

    def promo4
    end

    def promo5
    end

    def promo6
    end

    def promo7
    end

    def promo8
    end
  end
end