module Admin
  class SubscriptionAttendanceReportsController < AdminController
    layout false

    load_and_authorize_resource :group_subscription

    def new
      @report_params = TimeControl::Reports::GroupSubscriptionParams.new
    end

    def create
      @report_params = TimeControl::Reports::GroupSubscriptionParams.new(params.require(:report_params).permit!)
      @report_params.group_subscription = @group_subscription
      if @report_params.valid?
        TimeControl::Reports::BuildJob.enqueue(@report_params.as_json)
        render json: { successHtml: '<p>Запущена генерация отчёта. После завершения на указанную Вами почту придёт ссылка для скачивания.</p>' }
      else
        render json: { errors: @report_params.errors }
      end
    end
  end
end