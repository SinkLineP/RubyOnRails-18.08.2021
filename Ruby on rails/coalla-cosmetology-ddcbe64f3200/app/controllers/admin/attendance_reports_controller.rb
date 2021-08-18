module Admin
  class AttendanceReportsController < AdminController
    layout false

    before_action do
      authorize! :show, :attendance
    end

    def new
      @report_params = TimeControl::Reports::Params.new(begin_on: Date.today.beginning_of_month,
                                                        end_on: Date.today)
    end

    def create
      @report_params = TimeControl::Reports::Params.new(params.require(:report_params).permit!)
      if @report_params.valid?
        TimeControl::Reports::BuildJob.enqueue(@report_params.as_json)
        render json: { successHtml: '<p>Запущена генерация отчёта. После завершения на указанную Вами почту придёт ссылка для скачивания.</p>' }
      else
        render json: { errors: @report_params.errors }
      end
    end
  end
end