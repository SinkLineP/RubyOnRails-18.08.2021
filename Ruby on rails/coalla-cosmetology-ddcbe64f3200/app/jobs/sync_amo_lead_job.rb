SyncAmoLeadJob = Struct.new(:group_subscription_id) do
  def enqueue(job)
    group_subscription = GroupSubscription.find(group_subscription_id)
    Delayed::Job.find_by(id: group_subscription.update_job_id).try(:destroy) if group_subscription.update_job_id.present?
    group_subscription.update_columns(update_job_id: job.id)
  end

  def perform
    group_subscription = GroupSubscription.find(group_subscription_id)

    amo_id = group_subscription.amocrm_id
    return if amo_id.blank?
    lead = Amocrm::Entities::Lead.find(amo_id)
    return unless lead

    lead.promotion_source = group_subscription.promotion_source
    lead.promotion_id = group_subscription.promotion_id
    lead.last_modified = lead.actual_last_modified
    lead.save!

    group_subscription.update_columns(update_job_id: nil)
  end

  def failure(job)
    group_subscription = GroupSubscription.find_by(id: student_id)
    group_subscription.update_columns(update_job_id: nil) if group_subscription
    error = StandardError.new("Unable to update amoCRM contact. Job #{job.id}")
    error.set_backtrace(job.last_error)
    CustomExceptionNotifier.notify_exception(error)
  end

  def max_attempts
    2
  end
end