# == Schema Information
#
# Table name: amo_module_courses
#
#  id            :integer          not null, primary key
#  course_id     :integer
#  amo_module_id :integer
#  position      :integer          default(0), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_amo_module_courses_on_amo_module_id  (amo_module_id)
#  index_amo_module_courses_on_course_id      (course_id)
#

class AmoModuleCourse < ActiveRecord::Base
  belongs_to :amo_module, inverse_of: :amo_module_courses
  belongs_to :course, inverse_of: :amo_module_courses

  simple_acts_as_list scope: :amo_module
end
