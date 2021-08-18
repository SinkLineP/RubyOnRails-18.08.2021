# == Schema Information
#
# Table name: instructor_vacations
#
#  id            :integer          not null, primary key
#  instructor_id :integer
#  begin_on      :date             not null
#  end_on        :date             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_instructor_vacations_on_instructor_id  (instructor_id)
#

class InstructorVacation < ActiveRecord::Base
  belongs_to :instructor, inverse_of: :vacations

  validates :begin_on, :end_on, presence: true

  scope :ordered, -> { order(:created_at) }
end
