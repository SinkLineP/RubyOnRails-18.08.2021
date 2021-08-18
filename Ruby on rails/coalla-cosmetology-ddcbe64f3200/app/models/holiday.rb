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

class Holiday < ActiveRecord::Base
  with_options presence: true do
    validates :year
    validates :day, uniqueness: true
  end

  scope :with_year, ->(year) { where(year: year) }

  def day=(value)
    self.year = value.try(:year)
    super
  end
end
