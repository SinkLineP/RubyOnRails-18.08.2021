class StudentDocumentService
  def self.run
    StudentDocumentService.new.run
  end

  def run
    students = Student.joins(group_subscriptions: :course).where("group_subscriptions.end_on >= :date", date: Date.current)
                                                          .where(group_subscriptions: { amocrm_status_id: AmocrmStatus.success.id, expelled: false },
                                                                 courses: { short_name: %w(K KO KOV KV SK) }).uniq

    students.each do |student|
      NotificationMailer.notify_about_new_documents(student).deliver!
      SmsNotifications.new.notify_about_new_documents!(student)
    end
  end
end