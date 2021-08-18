# == Schema Information
#
# Table name: instructor_faculties
#
#  id            :integer          not null, primary key
#  instructor_id :integer
#  faculty_id    :integer
#  position      :integer          default(0), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_instructor_faculties_on_faculty_id     (faculty_id)
#  index_instructor_faculties_on_instructor_id  (instructor_id)
#

class InstructorFaculty < ActiveRecord::Base
  belongs_to :instructor, inverse_of: :instructor_faculties
  belongs_to :faculty, inverse_of: :instructor_faculties
end
