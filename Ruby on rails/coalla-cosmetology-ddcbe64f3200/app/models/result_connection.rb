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

class ResultConnection < Result
  has_many :result_connection_items, inverse_of: :result_connection, foreign_key: :result_id, dependent: :destroy

  accepts_nested_attributes_for :result_connection_items

  delegate :max_mark, to: :task

  def correct_answers_count
    @correct_answers_count ||= result_connection_items.to_a.count{|r| r.correct?}
  end

  def percent
    (mark / (task.column_variants.count.to_f * ConnectionTask::VARIANT_WEIGHT)) * 100
  end

  protected

  def call_marking_logic(options={})
    passed = task.passed?(correct_answers_count)
    mark = task.mark(correct_answers_count)
    assign_attributes(status: :marked, marked_at: Time.now, passed: passed, mark: mark)
  end
end
