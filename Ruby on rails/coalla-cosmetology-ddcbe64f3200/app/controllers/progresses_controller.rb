class ProgressesController < ApplicationController
  before_action :authenticate_user!

  before_action do
    authorize! :show, :progress
  end

  def show
    user_activities = current_user.user_activities.unscope(:order).order(:last_tracked_at)
    builder = GraphDataBuilder.new(user_activities)
    @activity_graph_data = builder.activity_graph_data
  end

end