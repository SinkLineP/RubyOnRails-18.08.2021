SyncAmoDataJob = Struct.new(:student_id) do
  def enqueue(job)
    student = Student.find(student_id)
    Delayed::Job.find_by(id: student.update_job_id).try(:destroy) if student.update_job_id.present?
    student.update_columns(update_job_id: job.id)
  end

  def perform
    student = Student.find(student_id)

    return if student.amocrm_id.blank?
    contact = Amocrm::Entities::Contact.find(student.amocrm_id)
    return unless contact

    contact.name = student.full_name
    contact.education_level_id = student.education_level_id
    contact.last_modified = contact.actual_last_modified
    contact.phone = student.phone if contact.try(:phone).blank? && student.phone.present?
    contact.save!

    student.update_columns(update_job_id: nil)
  end

  def failure(job)
    student = Student.find_by(id: student_id)
    student.update_columns(update_job_id: nil) if student
    error = StandardError.new("Unable to update amoCRM contact. Job #{job.id}")
    error.set_backtrace(job.last_error)
    CustomExceptionNotifier.notify_exception(error)
  end

  def max_attempts
    2
  end
end