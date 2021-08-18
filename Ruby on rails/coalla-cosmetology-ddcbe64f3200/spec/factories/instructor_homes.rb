# == Schema Information
#
# Table name: instructor_homes
#
#  id            :integer          not null, primary key
#  description   :text
#  active        :boolean          default(FALSE), not null
#  instructor_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do
  factory :instructor_home do
    
  end
end
