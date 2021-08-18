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

class ResultFile < Result
  include ManualMarkingLogic

  has_many :result_file_items, ->() { order(:position) }, inverse_of: :result_file, foreign_key: :result_id, dependent: :destroy

  validate :check_file_items

  accepts_nested_attributes_for :result_file_items

  after_create do
    CosmetologyMailer.lection_file_attached_notification(self).deliver if result_file_items.any? && group
  end

  def old_file_items(course)
    task.results
        .includes(:task)
        .where(student: student,
               type: 'ResultFile',
               tasks:
                   {
                       lecture_id: course.lectures.map(&:id)
                   })
        .where.not(id: id)
        .unscope(:order)
        .order(:created_at)
        .flat_map(&:result_file_items)
  end

  def percent
    mark
  end

  private

  def check_file_items
    errors.add(:base, :no_files) unless result_file_items.any?
  end
end
