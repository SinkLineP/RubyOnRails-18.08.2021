# == Schema Information
#
# Table name: call_results
#
#  id                    :integer          not null, primary key
#  status                :string
#  group_subscription_id :integer
#  duration              :integer
#  code                  :string
#  user_input            :string
#  processed             :boolean          default(FALSE), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_call_results_on_group_subscription_id  (group_subscription_id)
#

FactoryGirl.define do
  factory :call_result do
    status "MyString"
    group_subscription nil
    duration 1
    code "MyString"
  end
end
