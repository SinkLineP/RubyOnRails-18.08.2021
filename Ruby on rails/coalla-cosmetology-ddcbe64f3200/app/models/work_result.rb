# == Schema Information
#
# Table name: work_results
#
#  id         :integer          not null, primary key
#  group_id   :integer
#  work_id    :integer
#  marked_on  :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_work_results_on_group_id  (group_id)
#  index_work_results_on_work_id   (work_id)
#

class WorkResult < ActiveRecord::Base
  belongs_to :work, inverse_of: :work_result
  belongs_to :group, inverse_of: :work_results
  has_one :course, through: :group
  has_one :generated_document, as: :item, dependent: :destroy
  has_many :student_work_results, -> { by_alphabet }, inverse_of: :work_result, dependent: :destroy
  has_many :exercises, through: :work
  has_many :scans, inverse_of: :work_result, dependent: :destroy

  accepts_nested_attributes_for :student_work_results, allow_destroy: true
  accepts_nested_attributes_for :scans, allow_destroy: true

  ransacker :marked_on, type: :date

  delegate :with_exercises?,
           :with_sub_exercises?,
           :exam?,
           :ladder?,
           :practice_work?,
           :final_work?,
           to: :work, allow_nil: true
  delegate :title, to: :work, prefix: true, allow_nil: true
  delegate :title, to: :group, prefix: true, allow_nil: true

  validates :group_id, :work_id, :marked_on, presence: true

  after_save :generate_document!
  after_create :send_debt_notifications, if: :with_results?

  def without_results?
    student_work_results.any?(&:absent?)
  end

  def with_results?
    student_work_results.any?(&:result_present?)
  end

  def build_student_work_results
    return if work.blank? || group.blank?

    group.active_students.each do |student|
      build_exercise_result(student)
    end

    student_work_results
  end

  def send_debt_notifications
    student_work_results.each do |student_work_result|
      next if student_work_result.work_passed?

      group_subscription = student_work_result.group_subscription

      next if group_subscription.try(:in_academic_vacation?) || group_subscription.try(:expelled?)

      NotificationMailer.notify_student_academic_debt(student_work_result.student, work.title).deliver!
      NotificationMailer.notify_admin_about_academic_debt(student_work_result.student, work.title).deliver! unless Rails.env.staging?
    end
  end

  def generate_document!
    (generated_document || build_generated_document(type: "#{work.type}Sheet")).generate!(student_work_results: actual_student_work_results)
    student_work_results.each do |student_work_result|
      student_work_result.generate_document!
    end
  end

  def actual_student_work_results
    @actual_student_work_results ||= student_work_results.select { |r| !GroupSubscription.with_deleted.find_by(student_id: r.student_id, group_id: group_id).try(:in_academic_vacation?) }
  end

  private

  def build_exercise_result(student)
    result = student_work_results.build(student: student)

    return unless with_exercises?

    if !with_sub_exercises?
      exercises.each { |exercise| result.exercise_results.build(exercise: exercise, text: exercise.text) }
      return
    end

    exercises.each do |exercise|
      if exercise.exercises.blank?
        result.exercise_results.build(exercise: exercise, text: exercise.text)
        next
      end

      exercise.exercises.each { |child| result.exercise_results.build(exercise: child, text: child.text, parent_text: exercise.text) }
    end
  end

end
