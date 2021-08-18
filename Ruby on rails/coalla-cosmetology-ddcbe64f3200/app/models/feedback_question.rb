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

class FeedbackQuestion < ActiveRecord::Base
  extend Enumerize

  MAX_FILE_SIZE = 10
  TYPES = %w(StudyQuestion TechnicalQuestion ExpulsionQuestion AbsenteeismQuestion StudentComment OtherQuestion)

  belongs_to :student, inverse_of: :feedback_questions
  belongs_to :lecture, inverse_of: :feedback_questions

  mount_uploader :file, FileUploader

  enumerize :working_off_type, in: [:wc_document, :wc_change_group, :wc_vip, :c_with_group, :c_individual]

  delegate :display_name, to: :student, prefix: true, allow_nil: true
  delegate :email, to: :student, prefix: true, allow_nil: true

  attr_accessor :course_id

  validates :text, :type, presence: true

  def course
    # hook
  end

  TYPES.each do |type|
    method_name = "#{type.underscore.gsub('_question', '')}?"
    define_method method_name do
      is_a?(type.constantize)
    end
  end

  def filename
    file.try(:file).try(:filename)
  end

  def group_subscription
    group = Group.find_by(title: self.groups)
    return nil unless group.present?
    @group_subscription = GroupSubscription.find_by(group_id: group.id, student_id: self.student.id)
  end

  def send_mail
    Delayed::Job.enqueue(Amocrm::Operations::CreateTasks.new(3779901,
                                                             student.try(:amocrm_id),
                                                             group_subscription.try(:amocrm_id),
                                                             student.full_name,
                                                             student.email,
                                                             student.phone,
                                                             "СДО. #{ I18n.t('feedback_questions.' + type.underscore) }. #{ text }"),
                         queue: :amocrm)
  end

  def set_defaults
    return unless student
    assign_attributes(student_name: student.full_name,
                      groups: student.groups.map(&:title).join(",\s"),
                      phone: student.phone)
  end
end
