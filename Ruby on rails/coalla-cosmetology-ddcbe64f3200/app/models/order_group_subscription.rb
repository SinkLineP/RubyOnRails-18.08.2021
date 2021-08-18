# == Schema Information
#
# Table name: order_group_subscriptions
#
#  id                    :integer          not null, primary key
#  group_subscription_id :integer
#  order_id              :integer
#  created_at            :datetime
#  updated_at            :datetime
#  position              :integer          default(0), not null
#
# Indexes
#
#  index_order_group_subscriptions_on_group_subscription_id  (group_subscription_id)
#  index_order_group_subscriptions_on_order_id               (order_id)
#  index_order_group_subscriptions_on_position               (position)
#

class OrderGroupSubscription < ActiveRecord::Base

  belongs_to :order, inverse_of:  :order_group_subscriptions
  belongs_to :group_subscription, inverse_of: :order_group_subscriptions

  scope :ordered, -> { order(:created_at) }
  scope :order_by_position, -> { order(:position) }
  scope :academic_vacation, -> { joins(:group_subscription).where(group_subscriptions: {academic_vacation: true})}
  scope :not_academic_vacation, -> { joins(:group_subscription).where(group_subscriptions: {academic_vacation: false})}

  def subscriptions_count
    order.group_subscriptions.count
  end

end
