class VacanciesNotificationService

  NOTIFICATION_TITLE = 'vacancies_notification'

  def self.run
    VacanciesNotificationService.new.run
  end

  def run
    date = Time.current.yesterday
    vacancies = Vacancy.where(created_at: date.beginning_of_day..date.end_of_day).ordered
    students = Student.joins(group_subscriptions: :course).where(group_subscriptions: { amocrm_status_id: AmocrmStatus.success.id },
                                                      courses: { short_name: %w(K KO KOV KC KV SK SPA-M MM) }).uniq
    return unless vacancies.any?
    students.find_each do |student|
      next if student.rejected_subscriptions.exists?(notification_type: NOTIFICATION_TITLE)
      token = SymmetricEncryption.encrypt("#{student.email}|#{NOTIFICATION_TITLE}")
      CosmetologyMailer.vacancies_notification(student, vacancies, token).deliver_now!
    end
  end
end