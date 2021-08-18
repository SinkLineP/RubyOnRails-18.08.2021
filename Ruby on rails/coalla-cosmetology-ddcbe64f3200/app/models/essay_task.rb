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


class EssayTask < Task
end
