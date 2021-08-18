# == Schema Information
#
# Table name: user_activities
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  title           :text             not null
#  description     :text             not null
#  last_tracked_at :datetime         not null
#  spent_time      :integer          default(0), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  trackable_id    :integer
#  trackable_type  :string
#  event_type      :text             default("learning"), not null
#
# Indexes
#
#  index_user_activities_on_last_tracked_at                  (last_tracked_at)
#  index_user_activities_on_trackable_type_and_trackable_id  (trackable_type,trackable_id)
#  index_user_activities_on_user_id                          (user_id)
#  user_activity_index                                       (user_id,title,description)
#

class UserActivity < ActiveRecord::Base
  belongs_to :student, inverse_of: :user_activities, foreign_key: :user_id
  belongs_to :trackable, polymorphic: true

  with_options presence: true do
    validates :title, :description, :last_tracked_at
  end

  def result?
    trackable.try(:is_a?, Result)
  end
end
