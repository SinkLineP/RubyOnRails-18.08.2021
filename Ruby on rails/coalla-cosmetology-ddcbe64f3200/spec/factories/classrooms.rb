# == Schema Information
#
# Table name: classrooms
#
#  id          :integer          not null, primary key
#  title       :text             not null
#  capacity    :integer          default(0), not null
#  external_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :classroom do
    title "MyText"
    capacity 1
    external_id 1
  end
end
