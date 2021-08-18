# frozen_string_literal: true

# Отчет "Должники"
# @see app/views/admin/debtor_reports
# @see app/views/admin/students/index.html.haml
module Admin
  class DebtorReportsController < AdminController
    layout false

    def new; end

    def create
      @begin_at = params[:begin_at].presence
      @end_at = params[:end_at].presence

      scope = GroupSubscription
                  .preload(:student,
                           :group,
                           :payments,
                           group: [:course])
                  .joins(:student, :amocrm_status, :course)
                  .actual.not_expelled.not_academic_vacation
                  .order("users.last_name asc, users.first_name asc, users.middle_name asc")
      scope = scope.where("group_subscriptions.begin_on >= ?", Date.parse(@begin_at)) if @begin_at
      scope = scope.where("group_subscriptions.begin_on <= ?", Date.parse(@end_at)) if @end_at
      @group_subscriptions = scope

      @dates = @group_subscriptions.flat_map(&:payments)
                                   .delete_if { |p| p.payed_on.blank? }
                                   .sort_by(&:payed_on)
                                   .map { |p| p.payed_on && p.payed_on.beginning_of_month.to_date if p.payed_on.present? }.compact.uniq
      payment_logs = PaymentLog.where(group_id: @group_subscriptions.map(&:group_id), student_id: @group_subscriptions.map(&:student_id)).to_a
      current_time = Time.current

      @statistic = @group_subscriptions.map do |gs|
        plan = gs.payments.select { |p| p.payed_on && p.payed_on <= current_time }
        fact = payment_logs.select { |p| p.group_id == gs.group_id && p.student_id == gs.student_id && p.payed_on && p.payed_on <= current_time }

        fact_all = payment_logs.select { |p| p.group_id ==  gs.group_id && p.student_id == gs.student_id }
                       .sum(&:amount) || 0

        [
            gs,
            OpenStruct.new(left_to_pay: (plan.sum(&:amount) || 0) - (fact.sum(&:amount) || 0),
                           left_to_pay_all: gs.price - fact_all,
                            debt_dates: subscription_debt_dates(gs, payment_logs, current_time))
        ]
      end.to_h

      @statistic = @statistic.reject { |group_subscription, row| row.left_to_pay <= 0 }
    end

    private

    def subscription_debt_dates(group_subscription, payment_logs, current_time)
      fact_sum_all = payment_logs.select { |p| p.group_id == group_subscription.group_id && p.student_id == group_subscription.student_id && p.payed_on && p.payed_on <= current_time }.sum(&:amount) || 0
      dates = group_subscription.plan_payment_debt_dates(fact_sum_all, current_time)
      result = dates.map { |date| Russian.strftime(date, "%d.%m.%Y") }
      result.reject(&:blank?).join(", ")
    end
  end
end
