# Контроллер раздела "Календарь"
# @see app/views/admin/holidays
module Admin
  class HolidaysController < AdminController
    authorize_resource

    def index
      @year = (params[:year].presence || Date.current.year).to_i
      @holidays = Holiday.with_year(@year).pluck(:day)

      respond_to do |format|
        format.html { render :index }
        format.json { render json: { holidays: @holidays } }
      end
    end

    def create
      Holiday.find_or_create_by!(day: Date.parse(params[:day]))
      render nothing: true
    end

    def destroy
      holiday = Holiday.find_by(day: params[:id])
      holiday.destroy! if holiday
      render nothing: true
    end
  end
end