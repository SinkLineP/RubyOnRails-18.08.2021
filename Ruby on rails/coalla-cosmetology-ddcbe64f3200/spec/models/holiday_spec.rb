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

require 'rails_helper'

RSpec.describe Holiday, type: :model do
  it 'valid if day is specified' do
    expect(create(:holiday)).to be_valid
  end

  it 'invalid if day is not unique' do
    create(:holiday, day: Date.current)
    expect(build(:holiday, day: Date.current)).to be_invalid
  end

  describe '.with_year' do
    it 'returns correct holidays' do
      create(:holiday, day: Date.new(2017, 1, 1))
      first = create(:holiday, day: Date.new(2018, 1, 1))
      second = create(:holiday, day: Date.new(2018, 1, 2))
      expect(described_class.with_year(2018)).to contain_exactly(first, second)
    end
  end
end
