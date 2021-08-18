# == Schema Information
#
# Table name: schedule_items
#
#  id            :integer          not null, primary key
#  classroom_id  :integer
#  begin_at      :datetime
#  end_at        :datetime
#  day           :date
#  work_id       :integer
#  work_index    :integer          default(0), not null
#  instructor_id :integer
#  approved      :boolean          default(FALSE), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_schedule_items_on_classroom_id   (classroom_id)
#  index_schedule_items_on_instructor_id  (instructor_id)
#  index_schedule_items_on_work_id        (work_id)
#

class ScheduleItem < ActiveRecord::Base
  belongs_to :classroom, inverse_of: :schedule_items
  belongs_to :work, inverse_of: :schedule_items
  belongs_to :instructor, inverse_of: :schedule_items
  has_many :schedule_item_groups, dependent: :destroy, inverse_of: :schedule_item
  has_many :groups, through: :schedule_item_groups
  has_many :schedule_item_working_off_lists, dependent: :destroy, inverse_of: :schedule_item
  has_many :working_off_lists, through: :schedule_item_working_off_lists

  def similar_datetime?(other_item)
    begin_at == other_item.begin_at &&
      end_at == other_item.end_at
  end

  def overlapped?(other_item)
    !(begin_at >= other_item.end_at || end_at <= other_item.begin_at)
  end

  def places
    groups.sum(:distances_place) + working_off_lists.count
  end
end
