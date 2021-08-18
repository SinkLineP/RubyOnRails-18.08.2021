# frozen_string_literal: true

# Отчет "Оплата"
# @see app/views/admin/payment_statistics
# @see app/views/admin/students/index.html.haml
module Admin
  class PaymentStatisticsController < AdminController
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
                  .actual.not_expelled
                  .order("users.last_name asc, users.first_name asc, users.middle_name asc")
                  scope = scope.where("group_subscriptions.begin_on >= ?", Date.parse(@begin_at)) if @begin_at
                  scope = scope.where("group_subscriptions.begin_on <= ?", Date.parse(@end_at)) if @end_at
                  scope = scope.with_multiple_payments
                  @group_subscriptions = scope.to_a.uniq
      @dates = @group_subscriptions.flat_map(&:payments)
                                   .delete_if { |p| p.payed_on.blank? }
                                   .sort_by(&:payed_on)
                                   .map { |p| p.payed_on && p.payed_on.beginning_of_month.to_date }
                                   .compact.uniq
      payment_logs = PaymentLog.where(group_id: @group_subscriptions.map(&:group_id), student_id: @group_subscriptions.map(&:student_id)).to_a

      @statistic = @group_subscriptions.map do |gs|
        values = @dates.map do |date|
          OpenStruct.new(plan: gs.payments.select { |p| p.payed_on && date <= p.payed_on && p.payed_on <= date.end_of_month }.sum(&:amount) || 0,
                         fact: payment_logs.select { |p| p.payed_on && date <= p.payed_on && p.payed_on <= date.end_of_month && p.group_id == gs.group_id && p.student_id == gs.student_id }
                                   .sum(&:amount) || 0)
        end


        [
            gs,
            OpenStruct.new(payed: values.sum(&:fact),
                           left_to_pay: gs.price - values.sum(&:fact),
                           values: values)
        ]
      end.to_h
    end
  end
end
