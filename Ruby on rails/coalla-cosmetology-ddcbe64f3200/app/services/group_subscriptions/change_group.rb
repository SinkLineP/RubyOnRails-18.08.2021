# frozen_string_literal: true

module GroupSubscriptions
  class ChangeGroup
    def initialize(group_subscription)
      @group_subscription = group_subscription
      @new_group = @group_subscription.group
      @old_group_id = @group_subscription.group_id_was
      @old_group = Group.find_by(id: @old_group_id)
    end

    def perform
      return if @old_group_id.blank?
      @group_subscription.transaction do
        create_transfer!
        update_payment_logs
        recalculate_old_group_counters
        send_notifications
        duplicate_lead
      end
    end

    private

    def recalculate_old_group_counters
      return unless @old_group
      @old_group.recalculate_counters
    end

    def create_transfer!
      new_group_transfer = @group_subscription.group_transfers.create!(old_group_id: @old_group_id,
                                                                       new_group_id: @new_group.id)
      new_group_transfer.build_change_group_order.save! unless new_group_transfer.change_group_order
    end

    def update_payment_logs
      PaymentLog.where(group_id: @old_group_id, student_id: @group_subscription.student_id).update_all(group_id: @new_group.id)
    end

    def send_notifications
      return if @new_group.practices.blank? || @group_subscription.disabled_send?
      NotificationMailer.changed_group_title_notification(@group_subscription).deliver!
      SmsNotifications.new.notify_about_group_changing!(@group_subscription)
    rescue => ex
      Rails.logger.error("Couldn't notify user about group changing. #{ex.message}")
    end

    def duplicate_lead
      can_duplicate = @old_group.try(:fake?) && @group_subscription.amocrm_id.present? && !@group_subscription.status_changed_to_success?
      Delayed::Job.enqueue(Amocrm::Operations::DuplicateLead.new(@group_subscription.amocrm_id, @new_group.id), queue: :amocrm) if can_duplicate
    end
  end
end
