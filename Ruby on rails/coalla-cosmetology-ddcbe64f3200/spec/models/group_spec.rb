# == Schema Information
#
# Table name: groups
#
#  id                        :integer          not null, primary key
#  title                     :text
#  course_id                 :integer
#  instructor_id             :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  begin_on                  :date             not null
#  end_on                    :date             not null
#  distances_place           :integer          default(0), not null
#  distances_count           :integer          default(0), not null
#  academics_place           :integer          default(0), not null
#  academics_count           :integer          default(0), not null
#  start_time                :time             default("2000-01-01T09:00:00.000Z"), not null
#  end_time                  :time             default("2000-01-01T13:00:00.000Z"), not null
#  academic_on               :date
#  schedule_type             :text             default("specific_days"), not null
#  shift_work_on             :datetime
#  schedule_description      :text
#  week_days                 :text
#  deleted_at                :datetime
#  active                    :boolean          default(FALSE), not null
#  itec                      :datetime
#  fake                      :boolean          default(FALSE)
#  places_over_notified      :boolean          default(FALSE), not null
#  shop_id                   :integer
#  scheduled                 :boolean          default(FALSE), not null
#  webinar_link              :text
#  webinar_notification_sent :boolean          default(FALSE), not null
#  practice_address          :string
#
# Indexes
#
#  index_groups_on_course_id      (course_id)
#  index_groups_on_instructor_id  (instructor_id)
#  index_groups_on_shop_id        (shop_id)
#

require 'rails_helper'

RSpec.describe Group, type: :model do
  include_examples 'all attributes', [:course_id,
                                      :begin_on,
                                      :end_on,
                                      :start_time,
                                      :end_time,
                                      :distances_place,
                                      :distances_count,
                                      :academics_place,
                                      :academics_count]
end
