class CreateOrderGroupSubscriptions < ActiveRecord::Migration
  def change
    create_table :order_group_subscriptions do |t|
      t.references :group_subscription, index: true, foreign_key: true
      t.references :order, index: true, foreign_key: true
      t.timestamps
    end
  end
end
