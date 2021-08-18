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

FactoryGirl.define do
  factory :instructor_vacation do
    instructor nil
    begin_on "2018-07-11"
    end_on "2018-07-11"
  end
end
