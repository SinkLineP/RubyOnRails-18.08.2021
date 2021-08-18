# == Schema Information
#
# Table name: course_seos
#
#  id         :integer          not null, primary key
#  course_id  :integer
#  place      :string
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_course_seos_on_course_id  (course_id)
#  index_course_seos_on_place      (place)
#

class CourseSeo < ActiveRecord::Base
  extend Enumerize

  belongs_to :course, inverse_of: :course_seos
  validates_presence_of :course

  POSITION = ["block1", "header2", "block2"]

  default_scope { order(:id) }

  scope :block1, -> { where(place: 'block1') }
  scope :header2, -> { where(place: 'header2') }
  scope :block2, -> { where(place: 'block2') }

  enumerize :place, in: POSITION

end
