# == Schema Information
#
# Table name: consultations
#
#  id         :integer          not null, primary key
#  name       :text
#  email      :string
#  phone      :string
#  comment    :text
#  course_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_consultations_on_course_id  (course_id)
#

class Consultation < ActiveRecord::Base
  delegate :date, :time, :formatted_time, to: :used_time, allow_nil: true
  delegate :name, to: :course, allow_nil: true, prefix: true

  has_one :used_time, inverse_of: :consultation, dependent: :destroy
  belongs_to :course, inverse_of: :consultations

  accepts_nested_attributes_for :used_time

  validates :name, presence: true
  validates :email, presence: true, if: 'phone.blank?'
  validates :phone, presence: true, if: 'email.blank?'
  validates :phone, format: {with: /\A\d{6,11}\z/, allow_blank: true}
  validates :email, format: {with: Devise.email_regexp, allow_blank: true}

  scope :ordered, ->{ joins(:used_time).order('used_times.date DESC') }

  def date_time
    DateTime.new(date.year, date.month, date.day, time.hour, time.min)
  end

  def create_task_and_notify
    Delayed::Job.enqueue(Amocrm::Operations::CreateConsultationTask.new(id), queue: :amocrm)
    NotificationMailer.consultation(self).deliver!
  end
end
