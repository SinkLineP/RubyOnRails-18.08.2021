# == Schema Information
#
# Table name: instructor_works
#
#  id            :integer          not null, primary key
#  instructor_id :integer
#  work_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_instructor_works_on_instructor_id              (instructor_id)
#  index_instructor_works_on_instructor_id_and_work_id  (instructor_id,work_id) UNIQUE
#  index_instructor_works_on_work_id                    (work_id)
#

class InstructorWork < ActiveRecord::Base
  belongs_to :instructor, inverse_of: :instructor_works
  belongs_to :work, inverse_of: :instructor_works
end
