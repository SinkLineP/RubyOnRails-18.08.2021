module Admin
  class GroupAttendanceReportsController < AdminController
    layout false

    load_and_authorize_resource :group

    def new
      @report_params = TimeControl::Reports::GroupParams.new
    end

    def create
      @report_params = TimeControl::Reports::GroupParams.new(params.require(:report_params).permit!)
      @report_params.group = @group
      if @report_params.valid?
        TimeControl::Reports::BuildJob.enqueue(@report_params.as_json)
        render json: { successHtml: '<p>Запущена генерация отчёта. После завершения на указанную Вами почту придёт ссылка для скачивания.</p>' }
      else
        render json: { errors: @report_params.errors }
      end
    end
  end
end