# frozen_string_literal: true

class ContactsMerge
  include ActiveAttr::BasicModel
  include ActiveAttr::Attributes
  include ActiveAttr::MassAssignment
  include ActiveAttr::TypecastedAttributes

  ATTRIBUTES = [
    :last_name,
    :first_name,
    :middle_name,
    :education_level_id,
    :email,
    :emails_string,
    :birthday,
    :wear_size,
    :passport_series,
    :passport_number,
    :passport_issued_on,
    :passport_organisation,
    :passport_address,
    :address,
    :amocrm_id,
    :comagic_campaign,
    :phones_string
  ].freeze

  attribute :main_student_id
  attribute :other_student_id

  ATTRIBUTES.each do |attr_name|
    attribute attr_name
  end

  delegate :full_name_with_ids, to: :main_student, prefix: true, allow_nil: true
  delegate :full_name_with_ids, to: :other_student, prefix: true, allow_nil: true

  validates :main_student_id, :other_student_id, :last_name, presence: true
  validates :email, format: { with: Devise.email_regexp, allow_blank: true }
  validate :check_students

  def main_student
    @main_student ||= Student.find_by(id: main_student_id)
  end

  def other_student
    @other_student ||= Student.find_by(id: other_student_id)
  end

  def clear_attributes
    ATTRIBUTES.each do |attr_name|
      assign_attributes(attr_name => nil)
    end
  end

  def save
    save!
  rescue => ex
    Rails.logger.error("Couldn't merge contacts. #{ex.message}.\n#{ex.backtrace.join("\n")}")
    errors.add(:base, "Не удалось объединить контакты. Возникла непредвиденная ошибка. Пожалуйста, обратитесь к разработчикам.")
    false
  end

  def save!
    return false if invalid?
    main_student.transaction do
      authentications = other_student.authentications
      authentications = authentications.where.not(provider: main_student.authentications.pluck(:provider)) if main_student.authentications.exists?
      authentications.update_all(user_id: main_student_id)
      other_student.document_copies.update_all(item_id: main_student_id)
      other_student.student_documents.update_all(user_id: main_student_id)
      other_student.orders.update_all(user_id: main_student_id)
      other_student.sms.update_all(user_id: main_student_id)
      other_student.all_group_subscriptions.update_all(student_id: main_student_id)
      other_student.finished_materials.update_all(student_id: main_student_id)
      other_student.feedback_questions.update_all(student_id: main_student_id)
      other_student.deleted_notices.update_all(student_id: main_student_id)
      other_student.letters.update_all(student_id: main_student_id)
      other_student.personal_notices.update_all(student_id: main_student_id)
      other_student.notes.update_all(notable_id: main_student_id)
      other_student.payment_logs.update_all(student_id: main_student_id)
      other_student.expelled_students.update_all(student_id: main_student_id)
      other_student.student_work_results.update_all(student_id: main_student_id)
      other_student.comment_threads.update_all(commentable_id: main_student_id)
      other_student.results.update_all(student_id: main_student_id)
      other_student.user_activities.update_all(user_id: main_student_id)
      UserActivityService.new(main_student, {}).track_total_activity
      other_student.all_group_subscriptions.each(&:really_destroy!)
      other_student.user_phones.destroy
      main_student.user_phones.destroy
      other_student.destroy!
      ATTRIBUTES.each do |attr_name|
        main_student.assign_attributes(attr_name => self.send(attr_name))
      end
      main_student.save!
    end
    true
  end

  private

  def check_students
    return if main_student_id.blank? || other_student_id.blank?
    errors.add(:base, "Необходимо указать разные контакты") if main_student_id == other_student_id
  end
end
