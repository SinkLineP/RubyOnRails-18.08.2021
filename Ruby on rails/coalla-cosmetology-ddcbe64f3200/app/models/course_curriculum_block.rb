# == Schema Information
#
# Table name: course_curriculum_blocks
#
#  id                  :integer          not null, primary key
#  curriculum_block_id :integer
#  course_id           :integer
#  position            :integer          default(0), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_course_curriculum_blocks_on_course_id            (course_id)
#  index_course_curriculum_blocks_on_curriculum_block_id  (curriculum_block_id)
#  index_course_curriculum_blocks_on_position             (position)
#

class CourseCurriculumBlock < ActiveRecord::Base
  belongs_to :course, inverse_of: :course_curriculum_blocks
  belongs_to :curriculum_block, inverse_of: :course_curriculum_blocks

  simple_acts_as_list scope: :course
end
