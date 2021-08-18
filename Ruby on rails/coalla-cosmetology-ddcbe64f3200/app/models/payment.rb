# == Schema Information
#
# Table name: payments
#
#  id                    :integer          not null, primary key
#  group_subscription_id :integer
#  amount                :float            default(0.0), not null
#  payed_on              :date
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_payments_on_group_subscription_id  (group_subscription_id)
#

class Payment < ActiveRecord::Base
  belongs_to :group_subscription, inverse_of: :payments
  has_one :course, through: :group_subscription
  has_one :student, through: :group_subscription

  after_commit :update_one_time_payment_subscription

  private

  def update_one_time_payment_subscription
    group_subscription.reload
    return unless GroupSubscription::COURSES_FOR_PROMOTION.include?(course.short_name)
    group_subscription.update_one_time_payment
  end
end
