# == Schema Information
#
# Table name: amo_modules
#
#  id         :integer          not null, primary key
#  title      :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :amo_module do
    title 'Тестовый модуль'
  end
end
