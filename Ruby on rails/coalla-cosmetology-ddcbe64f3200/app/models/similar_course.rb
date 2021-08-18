# == Schema Information
#
# Table name: similar_courses
#
#  id         :integer          not null, primary key
#  similar_id :integer
#  course_id  :integer
#  position   :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_similar_courses_on_course_id   (course_id)
#  index_similar_courses_on_position    (position)
#  index_similar_courses_on_similar_id  (similar_id)
#

class SimilarCourse < ActiveRecord::Base
  belongs_to :course, inverse_of: :similar_courses
  belongs_to :similar, inverse_of: :similar_courses, class_name: :Course

  simple_acts_as_list scope: :course
end
