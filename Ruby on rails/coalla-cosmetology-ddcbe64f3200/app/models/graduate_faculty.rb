# == Schema Information
#
# Table name: graduate_faculties
#
#  id          :integer          not null, primary key
#  graduate_id :integer
#  faculty_id  :integer
#  position    :integer          default(0), not null
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_graduate_faculties_on_faculty_id   (faculty_id)
#  index_graduate_faculties_on_graduate_id  (graduate_id)
#

class GraduateFaculty < ActiveRecord::Base

  belongs_to :faculty, inverse_of: :graduate_faculties
  belongs_to :graduate, inverse_of: :graduate_faculties

  scope :ordered, -> { order(:created_at) }

end
