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


class ConnectionTask < Task
  PERCENT_FOR_PASSING = 0.6
  VARIANT_WEIGHT = 2

  has_many :column_variants, through: :columns

  def random_variants
    column_variants.unscope(:order).order('RANDOM()')
  end

  def max_mark
    column_variants.count * VARIANT_WEIGHT
  end

  def answers_for_passing_value
    (column_variants.count * PERCENT_FOR_PASSING).round
  end

  def passed?(correct_answer_count)
    correct_answer_count >= answers_for_passing_value
  end

  def mark(correct_answer_count)
    correct_answer_count * VARIANT_WEIGHT
  end
end
