module CoursesShop
  class ShopInfoController < BaseController

    layout false

    def show
      feed = Feed.find_by(name: :mindbox)
      @update_at = feed.updated_at
      feed.touch if params[:partner] == 'mindbox'
      @specialities = Speciality.order('parent_id DESC NULLS FIRST').alphabetical_order
      @courses = Course.preload(:specialities).alphabetical_order
    end
  end
end