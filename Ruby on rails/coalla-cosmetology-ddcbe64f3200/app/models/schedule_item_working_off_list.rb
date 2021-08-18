# == Schema Information
#
# Table name: schedule_item_working_off_lists
#
#  id                  :integer          not null, primary key
#  schedule_item_id    :integer
#  working_off_list_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_schedule_item_working_off_lists_on_schedule_item_id     (schedule_item_id)
#  index_schedule_item_working_off_lists_on_working_off_list_id  (working_off_list_id)
#

class ScheduleItemWorkingOffList < ActiveRecord::Base
  belongs_to :schedule_item, inverse_of: :schedule_item_working_off_lists
  belongs_to :working_off_list, inverse_of: :schedule_item_working_off_lists
end
