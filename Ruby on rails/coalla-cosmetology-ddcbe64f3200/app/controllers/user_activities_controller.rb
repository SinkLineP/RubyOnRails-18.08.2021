class UserActivitiesController < ApplicationController
  protect_from_forgery with: :null_session

  before_action :authenticate_user!

  def create
    UserActivityService.track(current_user, track_params)
    head :ok
  end

  private

  def track_params
    params.permit(:title, :description, :trackable_id, :trackable_type, :event_type)
  end

end