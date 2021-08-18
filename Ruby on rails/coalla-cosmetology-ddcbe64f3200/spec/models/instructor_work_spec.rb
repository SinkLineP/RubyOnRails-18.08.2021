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

require 'rails_helper'

RSpec.describe InstructorWork, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
