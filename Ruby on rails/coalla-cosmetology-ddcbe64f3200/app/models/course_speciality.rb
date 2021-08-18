# == Schema Information
#
# Table name: course_specialities
#
#  id            :integer          not null, primary key
#  course_id     :integer
#  speciality_id :integer
#  position      :integer          default(0), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_course_specialities_on_course_id      (course_id)
#  index_course_specialities_on_position       (position)
#  index_course_specialities_on_speciality_id  (speciality_id)
#

class CourseSpeciality < ActiveRecord::Base
  belongs_to :course, inverse_of: :course_specialities
  belongs_to :speciality, inverse_of: :course_specialities

  simple_acts_as_list scope: :course
end
