# == Schema Information
#
# Table name: course_recalls
#
#  id         :integer          not null, primary key
#  recall_id  :integer
#  course_id  :integer
#  position   :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_course_recalls_on_course_id  (course_id)
#  index_course_recalls_on_position   (position)
#  index_course_recalls_on_recall_id  (recall_id)
#

class CourseRecall < ActiveRecord::Base
  belongs_to :course, inverse_of: :course_recalls
  belongs_to :recall, inverse_of: :course_recalls

  simple_acts_as_list scope: :course
end
