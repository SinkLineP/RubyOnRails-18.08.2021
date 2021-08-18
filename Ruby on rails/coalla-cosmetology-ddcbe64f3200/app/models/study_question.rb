# == Schema Information
#
# Table name: feedback_questions
#
#  id               :integer          not null, primary key
#  type             :text             not null
#  student_id       :integer
#  instructor_id    :integer
#  index_id         :integer
#  text             :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  file             :text
#  student_name     :text
#  groups           :text
#  phone            :text
#  work_title       :text
#  absent_dates     :text
#  new_dates        :text
#  working_off_type :text
#  lecture_id       :integer
#
# Indexes
#
#  index_feedback_questions_on_lecture_id  (lecture_id)
#  index_feedback_questions_on_student_id  (student_id)
#

class StudyQuestion < FeedbackQuestion
  belongs_to :instructor

  before_validation :set_instructor, unless: :instructor

  delegate :name, to: :course, prefix: true, allow_nil: true
  delegate :block, to: :lecture

  def course
    @course ||= Course.find_by(id: course_id)
  end

  def lecture
    @lecture ||= student.current_lecture_for_course(course) if course.present?
  end

  def send_mail
    email = instructor.try(:email)
    if email.blank?
      # CosmetologyMailer.study_question_mail_without_instructor(self, course).deliver
      Delayed::Job.enqueue(Amocrm::Operations::CreateTasks.new(3779901,
                                                               student.try(:amocrm_id),
                                                               group_subscription.try(:amocrm_id),
                                                               student.full_name,
                                                               student.email,
                                                               student.phone,
                                                               "СДО. #{ I18n.t('feedback_questions.' + type.underscore) }. #{ text }"),
                           queue: :amocrm)
    else
      CosmetologyMailer.feedback_question_mail(emails, self).deliver
    end
  end

  private

  def set_instructor
    self.instructor = subscription.try(:instructor)
  end

  def subscription
    if course.present?
      student.group_subscription_for_course(course)
    else
      student.group_subscriptions.with_instructors.ordered.first
    end
  end
end
