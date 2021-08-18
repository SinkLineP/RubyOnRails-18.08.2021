# == Schema Information
#
# Table name: course_instructors
#
#  id            :integer          not null, primary key
#  instructor_id :integer
#  course_id     :integer
#  position      :integer          default(0), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_course_instructors_on_course_id      (course_id)
#  index_course_instructors_on_instructor_id  (instructor_id)
#  index_course_instructors_on_position       (position)
#

class CourseInstructor < ActiveRecord::Base
  belongs_to :course, inverse_of: :course_instructors
  belongs_to :instructor, inverse_of: :course_instructors

  simple_acts_as_list scope: :course
end
