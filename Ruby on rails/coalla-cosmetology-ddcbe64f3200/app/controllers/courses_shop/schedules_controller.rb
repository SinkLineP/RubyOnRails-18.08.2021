module CoursesShop
  class SchedulesController < BaseController
    before_action :authenticate_user!

    def show
      @group_subscriptions = current_user.available_subscriptions
    end

  end
end