class ErrorsController < ApplicationController
  def show
    @code = (params[:code].presence || 500).to_i
    if [400, 422, 500].include?(@code)
      render "#{@code}.html", layout: false
    else
      render '500.html', layout: false
    end
  end
end