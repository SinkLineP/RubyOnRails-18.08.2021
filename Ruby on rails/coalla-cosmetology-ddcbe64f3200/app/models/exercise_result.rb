# == Schema Information
#
# Table name: exercise_results
#
#  id                     :integer          not null, primary key
#  text                   :text
#  parent_text            :text
#  mark                   :integer
#  exercise_id            :integer
#  student_work_result_id :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_exercise_results_on_exercise_id             (exercise_id)
#  index_exercise_results_on_student_work_result_id  (student_work_result_id)
#

class ExerciseResult < ActiveRecord::Base
  belongs_to :exercise, inverse_of: :exercise_results
  belongs_to :student_work_result, inverse_of: :exercise_results

  validates_numericality_of :mark, only_integer: true, greater_than_or_equal_to: 0, allow_blank: true, unless: :absent?

  delegate :absent?, to: :student_work_result, allow_nil: true
end
