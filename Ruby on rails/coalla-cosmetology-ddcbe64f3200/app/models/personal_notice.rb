# == Schema Information
#
# Table name: personal_notices
#
#  id         :integer          not null, primary key
#  message    :text
#  read       :boolean          default(FALSE), not null
#  student_id :integer
#  lecture_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_personal_notices_on_lecture_id  (lecture_id)
#  index_personal_notices_on_student_id  (student_id)
#

class PersonalNotice < ActiveRecord::Base
  belongs_to :student, inverse_of: :personal_notices
  belongs_to :lecture, inverse_of: :personal_notices

  scope :unread, ->(){ where(read: false) }
end
