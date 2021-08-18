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

class ResultTest < Result
  has_many :result_test_items, inverse_of: :result_test, foreign_key: :result_id, dependent: :destroy

  accepts_nested_attributes_for :result_test_items

  validate :check_test_items

  delegate :max_mark, to: :task

  def max_mark?
    max_mark == mark
  end

  def prepare
    task.random_questions.each { |question| result_test_items.build(question: question) }
  end

  def correct_answers_count
    @correct_answers_count ||= result_test_items.to_a.count{ |r| r.correct? }
  end

  def percent
    (mark.to_i / (task.items_count.to_f * TestTask::QUESTION_WEIGHT)) * 100
  end

  private

  def check_test_items
    errors.add(:base, :all_answers_required) if result_test_items.any? { |r| r.question_answer.blank? }
  end

  def call_marking_logic(options={})
    passed = task.passed?(correct_answers_count)
    mark = task.mark(correct_answers_count)
    assign_attributes(status: :marked, marked_at: Time.now, passed: passed, mark: mark)
  end
end
