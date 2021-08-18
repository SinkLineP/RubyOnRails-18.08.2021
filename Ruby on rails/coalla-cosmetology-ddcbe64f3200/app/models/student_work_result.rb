# == Schema Information
#
# Table name: student_work_results
#
#  id             :integer          not null, primary key
#  work_result_id :integer
#  student_id     :integer
#  absent         :boolean          default(TRUE), not null
#  passed         :boolean          default(FALSE), not null
#  content        :integer
#  typography     :integer
#  protection     :integer
#  total          :integer
#  presence       :integer
#  customer_care  :integer
#  hygiene        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  ergonomic      :integer
#
# Indexes
#
#  index_student_work_results_on_student_id      (student_id)
#  index_student_work_results_on_work_result_id  (work_result_id)
#

class StudentWorkResult < ActiveRecord::Base
  PASS_MARK = 60
  ABSENT_TEXT = 'н/я'
  BLANK_MARK = ''
  PASSED_TEXT = 'Зачет'
  NOT_PASSED_TEXT = 'Не зачет'
  LADDER_PASSED_POINTS = 100
  LADDER_NOT_PASSED_POINTS = 0

  belongs_to :work_result, inverse_of: :student_work_results
  belongs_to :student, inverse_of: :student_work_results
  has_one :work, through: :work_result
  has_one :generated_document, as: :item, dependent: :destroy
  has_many :exercise_results, -> { order(:created_at) }, dependent: :destroy, inverse_of: :student_work_result
  has_one :group, through: :work_result
  has_one :course, through: :work_result

  accepts_nested_attributes_for :exercise_results, allow_destroy: true

  delegate :with_exercises?,
           :with_sub_exercises?,
           :exam?,
           :ladder?,
           :practice_work?,
           :final_work?,
           to: :work_result, allow_nil: true
  delegate :full_name, to: :student, allow_nil: true, prefix: true
  delegate :work_title, to: :work_result

  attr_accessor :index

  scope :not_absent, ->() { where(absent: false) }
  scope :absent, ->() { where(absent: true) }
  scope :by_alphabet, ->() { joins(:student).order('users.last_name ASC, users.first_name ASC, users.middle_name ASC') }

  before_validation :exercise_results_mark_will_change!, if: :absent_changed?

  def group_subscription
    @group_subscription ||= GroupSubscription.find_by(student_id: student_id, group_id: group.id)
  end

  def not_absent?
    !absent?
  end

  def single_mark?
    ladder? || final_work? || !with_exercises?
  end

  def work_passed?
    not_absent? && (total_mark >= PASS_MARK || passed?)
  end

  def result_present?
    not_absent? && (total_mark > 0 || passed?)
  end

  def total_mark
    return total.to_i if single_mark?

    result = exercise_results.to_a.map(&:mark).reject(&:blank?).sum

    return result if with_sub_exercises?

    result + presence.to_i + customer_care.to_i + hygiene.to_i
  end

  def display_total_mark
    return ABSENT_TEXT if absent?

    if ladder?
      passed? ? PASSED_TEXT : NOT_PASSED_TEXT
    else
      total_mark == 0 ? BLANK_MARK : total_mark
    end
  end

  def total_mark_for_rating
    return 0 if absent?

    if ladder?
      passed? ? LADDER_PASSED_POINTS : LADDER_NOT_PASSED_POINTS
    else
      total_mark
    end
  end

  def display_content
    return ABSENT_TEXT if absent?
    content
  end

  def display_typography
    return ABSENT_TEXT if absent?
    typography
  end

  def display_protection
    return ABSENT_TEXT if absent?
    protection
  end

  def display_presence
    return BLANK_MARK if absent?
    presence
  end

  def display_customer_care
    return BLANK_MARK if absent?
    customer_care
  end

  def display_hygiene
    return BLANK_MARK if absent?
    hygiene
  end

  def display_ergonomic
    return BLANK_MARK if absent?
    ergonomic
  end

  def subtotal
    [presence, customer_care, hygiene, ergonomic].reject(&:blank?).sum
  end

  def exercise_results_mark_will_change!
    exercise_results.each { |exercise_result| exercise_result.mark_will_change! }
  end

  def generate_document!
    (generated_document || build_generated_document(type: "#{work.type}Sheet")).generate!(item: work_result, student_work_results: [self], absent: true)
  end
end
