# == Schema Information
#
# Table name: group_prices
#
#  id                      :integer          not null, primary key
#  amount                  :integer          default(0), not null
#  payments_text           :text             not null
#  group_id                :integer
#  created_at              :datetime
#  updated_at              :datetime
#  education_form_id       :integer
#  early_booking           :boolean          default(FALSE)
#  bank_installment        :boolean          default(FALSE)
#  bank_installment_months :integer          default(0)
#
# Indexes
#
#  index_group_prices_on_education_form_id  (education_form_id)
#  index_group_prices_on_group_id           (group_id)
#

FactoryGirl.define do
  factory :group_price do
    association :group
    payments_text '1000;1000'
    amount 2000
  end
end
