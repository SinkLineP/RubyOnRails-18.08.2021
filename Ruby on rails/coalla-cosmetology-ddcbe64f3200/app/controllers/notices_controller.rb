class NoticesController < ApplicationController
  load_and_authorize_resource

  def destroy
    current_user.delete_notice!(@notice)
    render nothing: true
  end
end