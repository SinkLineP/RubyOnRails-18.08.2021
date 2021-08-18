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

class Result < ActiveRecord::Base
  extend Enumerize

  belongs_to :student, inverse_of: :results
  belongs_to :task
  has_one :lecture, through: :task
  has_one :block, through: :task
  belongs_to :instructor
  has_many :user_activities, ->() { order(last_tracked_at: :desc) }, as: :trackable, dependent: :nullify

  delegate :max_attempts_count, to: :task
  delegate :answer, to: :task, prefix: true, allow_nil: true
  delegate :lecture_index, :description, to: :lecture

  enumerize :status, in: [:new, :time_expired, :on_mark, :marked], default: :new, predicates: true

  scope :passed, ->() { where(status: :marked, passed: true) }
  scope :on_mark, ->() { where(status: :on_mark) }
  scope :for_student, ->(student) { where(student: student) }

  delegate :title, to: :task

  def attempts
    self.class.where(student_id: student_id, task_id: task_id)
  end

  def course
    @course ||= student.available_courses.detect { |course| course.lecture_ids.include?(lecture.id) }
  end

  def group
    @group ||= course.groups.joins(:students).where(users: { id: student_id }).first if course
  end

  def file?
    is_a?(ResultFile)
  end

  def attempt
    @attempt ||= _calculate_attempt
  end

  def type_name
    self.class.name.gsub('Result', '')
  end

  def expire!
    assign_attributes(status: :time_expired)
    save!(validate: false)
  end

  def description_for_activity
    return attempt_text if new?
    return "Не сдано. Время истекло. #{attempt_text}" if time_expired?
    return "Ожидает оценки. #{attempt_text}" if on_mark?
    if passed?
      "Сдано. #{attempt_text}. Оценка: #{mark} из #{max_mark}"
    else
      "Не сдано. #{attempt_text}. Оценка: #{mark} из #{max_mark}"
    end
  end

  def attempt_text
    "Попытка #{attempt}#{max_attempts_count && " из #{max_attempts_count}"}"
  end

  def mark_result(options = {})
    # логика определяется в наследниках
    call_marking_logic(options)
    save
  end

  def mark_result!(options = {})
    # логика определяется в наследниках
    call_marking_logic(options)
    save!
  end

  def manual_marking?
    false
  end

  protected

  # hook method
  def call_marking_logic(options = {})
  end

  private

  def _calculate_attempt
    return attempts.count + 1 if new_record?
    attempts.map(&:id).index(id).to_i + 1
  end
end
