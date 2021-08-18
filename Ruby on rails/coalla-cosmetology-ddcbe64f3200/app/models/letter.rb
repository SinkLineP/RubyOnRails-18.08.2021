# == Schema Information
#
# Table name: letters
#
#  id            :integer          not null, primary key
#  folder        :text             not null
#  subject       :text
#  body          :text
#  read          :boolean          default(FALSE), not null
#  sent_at       :datetime         not null
#  student_id    :integer          not null
#  instructor_id :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  uid           :integer
#  message_id    :text             not null
#
# Indexes
#
#  index_letters_on_instructor_id  (instructor_id)
#  index_letters_on_message_id     (message_id) UNIQUE
#  index_letters_on_student_id     (student_id)
#


class Letter < ActiveRecord::Base
  extend Enumerize

  belongs_to :student, inverse_of: :letters
  belongs_to :instructor, inverse_of: :letters
  has_many :attachments, dependent: :destroy, inverse_of: :letter

  enumerize :folder, in: [:inbound, :outbound]

  scope :inbound, ->() { where(folder: :inbound) }
  scope :outbound, ->() { where(folder: :outbound) }
  scope :ordered, ->() { order(sent_at: :desc) }
  scope :unread, ->() { where(read: false) }
  scope :with_uids, ->() { where.not(uid: nil) }

  delegate :email, to: :student, prefix: true, allow_nil: true

  validates_presence_of :student_id

  def unread?
    !read?
  end

  def mark_as_read
    update_column(:read, true)
  end

  def student_email=(value)
    return if value.blank?
    self.student = Student.find_by(email: value)
  end
end
