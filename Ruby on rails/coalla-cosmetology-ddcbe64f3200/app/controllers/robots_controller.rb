class RobotsController < ActionController::Base

  def robots
    robots = File.read(Rails.root.join('public', 'robots.sdo.txt').to_s)
    respond_to do |format|
      format.txt { render text: robots, layout: false }
    end
  end

end
