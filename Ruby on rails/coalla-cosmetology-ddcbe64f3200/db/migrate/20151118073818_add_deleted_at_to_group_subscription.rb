class AddDeletedAtToGroupSubscription < ActiveRecord::Migration
  def change
    add_column :group_subscriptions, :deleted_at, :datetime
    add_index :group_subscriptions, :deleted_at
  end
end
