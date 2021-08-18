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

require 'rails_helper'

RSpec.describe ScheduleItemGroup, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
