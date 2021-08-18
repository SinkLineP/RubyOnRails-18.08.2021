# == Schema Information
#
# Table name: expulsions
#
#  id             :integer          not null, primary key
#  group_id       :integer
#  personal       :boolean          default(TRUE), not null
#  non_attendance :boolean          default(TRUE), not null
#  expelled_on    :date
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_expulsions_on_group_id  (group_id)
#

class Expulsion < ActiveRecord::Base
  belongs_to :group, inverse_of: :expulsions
  has_many :expelled_students, inverse_of: :expulsion, dependent: :destroy
  has_one :expulsion_order, as: :item, dependent: :destroy
  has_one :course, through: :group

  attr_accessor :expelled_students_changed

  scope :expelled_not_by_hands, -> { where(personal: false, non_attendance: false) }
  scope :for_student, ->(student) { joins(:expelled_students).where(expelled_students: {student_id: student.id}) }

  accepts_nested_attributes_for :expelled_students, allow_destroy: true
  accepts_nested_attributes_for :expulsion_order

  after_save :generate_expulsion_order!

  def generate_expulsion_order!
    (expulsion_order || build_expulsion_order).generate!
  end

  def at_the_end_of_education?
    !non_attendance? && !personal?
  end
end
