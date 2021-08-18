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

FactoryGirl.define do
  factory :work_classroom do
    work nil
    classroom nil
  end
end
