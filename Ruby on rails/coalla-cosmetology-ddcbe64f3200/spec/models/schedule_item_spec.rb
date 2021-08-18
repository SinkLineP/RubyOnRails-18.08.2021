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

require 'rails_helper'

RSpec.describe ScheduleItem, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
