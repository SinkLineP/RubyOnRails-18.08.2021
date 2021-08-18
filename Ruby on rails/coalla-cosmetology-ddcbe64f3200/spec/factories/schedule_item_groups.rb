# == Schema Information
#
# Table name: schedule_item_groups
#
#  id               :integer          not null, primary key
#  schedule_item_id :integer
#  group_id         :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_schedule_item_groups_on_group_id          (group_id)
#  index_schedule_item_groups_on_schedule_item_id  (schedule_item_id)
#

FactoryGirl.define do
  factory :schedule_item_group do
    schedule_item nil
    group nil
  end
end
