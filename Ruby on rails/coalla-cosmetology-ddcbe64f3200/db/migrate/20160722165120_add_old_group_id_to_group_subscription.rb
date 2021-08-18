class AddOldGroupIdToGroupSubscription < ActiveRecord::Migration
  def change
    add_column :group_subscriptions, :old_group_id, :integer
  end
end
