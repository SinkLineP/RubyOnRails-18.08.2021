# == Schema Information
#
# Table name: cash_receipts
#
#  id         :integer          not null, primary key
#  code       :integer
#  uuid       :integer
#  response   :text
#  item_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  request    :text
#  item_type  :string           default("Order")
#
# Indexes
#
#  index_cash_receipts_on_item_id  (item_id)
#

class CashReceipt < ActiveRecord::Base
  belongs_to :item, polymorphic: true

  def group_subscription
    item if item && item.is_a?(GroupSubscription)
  end

  def order
    item if item && item.is_a?(Order)
  end
end
