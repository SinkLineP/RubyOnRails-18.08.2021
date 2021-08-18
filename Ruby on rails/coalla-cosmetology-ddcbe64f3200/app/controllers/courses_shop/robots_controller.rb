module CoursesShop
  class RobotsController < BaseController

    def robots
      robots = File.read(Rails.root.join('public', "robots.#{current_shop.code}.txt").to_s)
      respond_to do |format|
        format.txt { render text: robots, layout: false }
      end
    end

  end
end
