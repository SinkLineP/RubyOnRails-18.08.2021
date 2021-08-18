# == Schema Information
#
# Table name: user_total_activities
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  last_tracked_at  :datetime         not null
#  spent_time       :integer          default(0), not null
#  today_spent_time :integer          default(0), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_user_total_activities_on_user_id  (user_id)
#


class UserTotalActivity < ActiveRecord::Base
  belongs_to :user, inverse_of: :user_total_activity
end
