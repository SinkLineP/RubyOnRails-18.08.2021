# == Schema Information
#
# Table name: expelled_students
#
#  id           :integer          not null, primary key
#  hours        :integer          default(0), not null
#  expulsion_id :integer
#  student_id   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_expelled_students_on_expulsion_id  (expulsion_id)
#  index_expelled_students_on_student_id    (student_id)
#

class ExpelledStudent < ActiveRecord::Base
  belongs_to :student, inverse_of: :expelled_students
  belongs_to :expulsion, inverse_of: :expelled_students
  has_one :expulsion_order, through: :expulsion

  validates_presence_of :student_id
  validates_numericality_of :hours, greater_than_or_equal_to: 0, only_integer: true

  delegate :full_name, to: :student

  attr_accessor :index

  after_create do
    unless expulsion.at_the_end_of_education?
      GroupSubscription.where(group_id: expulsion.group_id,
                              student_id: student_id)
          .update_all(expelled: true)
      expulsion.group.recalculate_counters
      NotificationMailer.notify_about_expulsion(expulsion, student).deliver!
    end
  end

  after_destroy do
    unless expulsion.at_the_end_of_education?
      GroupSubscription.where(group_id: expulsion.group_id,
                              student_id: student_id)
          .update_all(expelled: false)
      expulsion.group.recalculate_counters
    end
  end
end
