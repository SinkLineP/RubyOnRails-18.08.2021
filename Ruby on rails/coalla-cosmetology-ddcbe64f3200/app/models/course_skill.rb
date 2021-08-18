# == Schema Information
#
# Table name: course_skills
#
#  id         :integer          not null, primary key
#  skill_id   :integer
#  course_id  :integer
#  position   :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_course_skills_on_course_id  (course_id)
#  index_course_skills_on_position   (position)
#  index_course_skills_on_skill_id   (skill_id)
#

class CourseSkill < ActiveRecord::Base
  belongs_to :course, inverse_of: :course_skills
  belongs_to :skill, inverse_of: :course_skills

  simple_acts_as_list scope: :course
end
