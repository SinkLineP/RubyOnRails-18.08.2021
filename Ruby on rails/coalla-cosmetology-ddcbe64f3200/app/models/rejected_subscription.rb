# == Schema Information
#
# Table name: rejected_subscriptions
#
#  id                :integer          not null, primary key
#  user_id           :integer          not null
#  notification_type :text             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_rejected_subscriptions_on_notification_type  (notification_type)
#  index_rejected_subscriptions_on_user_id            (user_id)
#

class RejectedSubscription < ActiveRecord::Base

  belongs_to :user, inverse_of: :rejected_subscriptions

end
