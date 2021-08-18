# == Schema Information
#
# Table name: course_blocks
#
#  id         :integer          not null, primary key
#  block_id   :integer
#  course_id  :integer
#  position   :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_course_blocks_on_block_id   (block_id)
#  index_course_blocks_on_course_id  (course_id)
#


class CourseBlock < ActiveRecord::Base
  belongs_to :course, inverse_of: :course_blocks
  belongs_to :block, inverse_of:  :course_blocks

  simple_acts_as_list scope: :course
end
