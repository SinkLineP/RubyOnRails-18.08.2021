class AddPositionToOrderGroupSubscription < ActiveRecord::Migration
  def change
    add_column :order_group_subscriptions, :position, :integer, null: false, default: 0
    add_index :order_group_subscriptions, :position
  end
end
