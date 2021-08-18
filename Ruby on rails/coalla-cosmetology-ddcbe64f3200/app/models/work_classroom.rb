# == Schema Information
#
# Table name: work_classrooms
#
#  id           :integer          not null, primary key
#  work_id      :integer
#  classroom_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_work_classrooms_on_classroom_id              (classroom_id)
#  index_work_classrooms_on_work_id                   (work_id)
#  index_work_classrooms_on_work_id_and_classroom_id  (work_id,classroom_id) UNIQUE
#

class WorkClassroom < ActiveRecord::Base
  belongs_to :work, inverse_of: :work_classrooms
  belongs_to :classroom, inverse_of: :work_classrooms

  validates :work_id, presence: true, uniqueness: { scope: :classroom_id }
end
