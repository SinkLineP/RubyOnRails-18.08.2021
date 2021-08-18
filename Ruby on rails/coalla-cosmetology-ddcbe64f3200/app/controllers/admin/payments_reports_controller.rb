# Отчет "Платежи"
# @see app/views/admin/payments_reports
# @see app/views/admin/students/index.html.haml
module Admin
  class PaymentsReportsController < AdminController
    layout false

    def new; end

    def create
      @begin_at = params[:begin_at].presence
      @end_at = params[:end_at].presence

      scope = PaymentLog.includes(:group, :student, group: :course)
      scope = scope.where('payment_logs.payed_on >= ?', Date.parse(@begin_at)) if @begin_at
      scope = scope.where('payment_logs.payed_on <= ?', Date.parse(@end_at)) if @end_at
      @payment_logs = scope
    end
  end
end