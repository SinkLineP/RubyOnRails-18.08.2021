# == Schema Information
#
# Table name: tasks
#
#  id                 :integer          not null, primary key
#  type               :text
#  title              :text
#  description        :text
#  answer             :text
#  lecture_id         :integer
#  max_answer_length  :integer
#  max_attempts_count :integer
#  time_limit         :integer
#  items_count        :integer
#  created_at         :datetime
#  updated_at         :datetime
#  final              :boolean          default(FALSE), not null
#
# Indexes
#
#  index_tasks_on_lecture_id  (lecture_id)
#


class TestTask < Task
  PERCENT_FOR_PASSING = 0.6
  QUESTION_WEIGHT = 2

  def random_questions
    questions.unscope(:order).order('RANDOM()').limit(items_count.to_i)
  end

  def display_name
    title.presence || super
  end

  def max_mark
    items_count.to_i * QUESTION_WEIGHT
  end

  def answers_for_passing_value
    (items_count.to_i * PERCENT_FOR_PASSING).round
  end

  def passed?(correct_answer_count)
    correct_answer_count >= answers_for_passing_value
  end

  def mark(correct_answer_count)
    correct_answer_count * QUESTION_WEIGHT
  end
end
