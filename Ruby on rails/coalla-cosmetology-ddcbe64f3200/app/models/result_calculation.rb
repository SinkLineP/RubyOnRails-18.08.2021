# == Schema Information
#
# Table name: results
#
#  id            :integer          not null, primary key
#  type          :text             not null
#  instructor_id :integer
#  student_id    :integer
#  task_id       :integer
#  status        :text             not null
#  answer        :text
#  passed        :boolean          default(FALSE), not null
#  mark          :integer
#  marked_at     :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  comment       :text
#
# Indexes
#
#  index_results_on_instructor_id  (instructor_id)
#  index_results_on_student_id     (student_id)
#  index_results_on_task_id        (task_id)
#

class ResultCalculation < Result
  CALCULATION_MARK = 100

  validates_presence_of :answer

  def percent
    mark
  end

  def max_mark
    CALCULATION_MARK
  end

  protected

  def call_marking_logic(options={})
    passed = task.passed?(answer)
    assign_attributes(status: :marked, marked_at: Time.now, passed: passed, mark: CALCULATION_MARK)
  end
end
