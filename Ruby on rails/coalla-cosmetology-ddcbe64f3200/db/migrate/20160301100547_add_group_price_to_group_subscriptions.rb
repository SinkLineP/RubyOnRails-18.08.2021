class AddGroupPriceToGroupSubscriptions < ActiveRecord::Migration
  def change
    add_reference :group_subscriptions, :group_price, index: true, foreign_key: true
  end
end
