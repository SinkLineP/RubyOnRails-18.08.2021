# == Schema Information
#
# Table name: holidays
#
#  id         :integer          not null, primary key
#  year       :integer          not null
#  day        :date             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_holidays_on_day   (day) UNIQUE
#  index_holidays_on_year  (year)
#

FactoryGirl.define do
  factory :holiday do
    day { Date.current }
  end
end
