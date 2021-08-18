# == Schema Information
#
# Table name: course_seos
#
#  id         :integer          not null, primary key
#  course_id  :integer
#  place      :string
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_course_seos_on_course_id  (course_id)
#  index_course_seos_on_place      (place)
#

FactoryGirl.define do
  factory :course_seo do
    course nil
    position "MyString"
    content "MyText"
  end
end
