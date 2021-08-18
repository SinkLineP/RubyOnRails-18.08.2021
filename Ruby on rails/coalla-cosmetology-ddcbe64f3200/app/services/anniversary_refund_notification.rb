class AnniversaryRefundNotification
  AMOUNT_LIMIT = 20000

  def initialize
    expelled = GroupSubscription.expelled.pluck(:student_id).uniq
    vacation = GroupSubscription.academic_vacation.pluck(:student_id).uniq
    @student_ids = GroupSubscription.actual.where.not(student_id: expelled + vacation).pluck(:student_id).uniq
  end

  def run
    Student.where(id: students_with_payments.keys).find_each do |student|
      NotificationMailer.notify_about_anniversary_refund(student, students_with_payments[student.id]).deliver
    end
  end

  def students_with_payments
    @students_with_payments ||= PaymentLog.where(student_id: @student_ids).having('SUM(amount) > ?', AMOUNT_LIMIT).group(:student_id).sum(:amount)
  end

  def to_csv
    CSV.open(File.join(Rails.root, "anniversary_refund_notification.csv"), 'wb') do |csv|
      csv << ['ФИО', 'Ссылка на АМО', 'Телефон', 'E-mail', 'XXX', 'YYY', 'Ответственный менеджер']

      Student.where(id: students_with_payments.keys).find_each do |student|
        payments_sum = students_with_payments[student.id]
        refund = payments_sum * 0.3
        contact = Amocrm::Entities::Contact.find(student.amocrm_id)
        csv << [student.full_name, student.amocrm_url, student.phone, student.email, payments_sum.round, refund.round, load_responsible_user(contact)]
      end
    end
  end

  def add_notes
    Student.where(id: students_with_payments.keys).find_each do |student|
      payments_sum = students_with_payments[student.id]
      refund = payments_sum * 0.3
      create_amo_note!(student.amocrm_id, payments_sum.round, refund.round)
    end
  end

  def create_amo_note!(amocrm_id, payments_sum, refund)
    return if amocrm_id.blank?

    amo_note = Amocrm::Entities::Note.new(element_id: amocrm_id,
                                          element_type: Amocrm::ElementType::CONTACT,
                                          note_type: Note::COMMENT,
                                          date_create: Time.now,
                                          text: "Акция: клиент оплатил #{payments_sum}, бонус #{refund}")
    amo_note.save!
    amo_note
  end

  def load_responsible_user(contact)
    return if contact.blank?

    user = Amorail.properties.data['users'].detect { |user| user['id'] == contact.responsible_user_id.to_s }
    return if user.blank?

    user['name']
  end
end