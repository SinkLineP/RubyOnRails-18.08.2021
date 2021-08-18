# == Schema Information
#
# Table name: course_advantages
#
#  id           :integer          not null, primary key
#  advantage_id :integer
#  course_id    :integer
#  position     :integer          default(0), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_course_advantages_on_advantage_id  (advantage_id)
#  index_course_advantages_on_course_id     (course_id)
#  index_course_advantages_on_position      (position)
#

class CourseAdvantage < ActiveRecord::Base
  belongs_to :course, inverse_of: :course_advantages
  belongs_to :advantage, inverse_of: :course_advantages

  simple_acts_as_list scope: :course
end
