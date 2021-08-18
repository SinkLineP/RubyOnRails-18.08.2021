class UsedTimesController < ApplicationController
  include UsedTimesHelper

  def index
    used_time = UsedTime.new(date: params[:date])
    if used_time.date.present?
      render json: {selectOptions: time_select_options(used_time, params[:skip_all_day].presence)}
    else
      render json: {}
    end
  end
end