module CoursesShop
  class PromotionInfoController < BaseController

    layout false

    def show
      @promotions = Promotion.ordered
    end
  end
end