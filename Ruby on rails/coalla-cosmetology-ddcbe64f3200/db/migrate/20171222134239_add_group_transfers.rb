class AddGroupTransfers < ActiveRecord::Migration
  def up
    GroupSubscription.where.not(old_group_id: nil).find_each do |subscription|
      group_transfer = GroupTransfer.create!(old_group_id: subscription.old_group_id, new_group_id: subscription.group.id, group_subscription: subscription)
      ChangeGroupOrder.where(item_id: subscription.id, item_type: subscription.model_name.to_s).update_all(item_id: group_transfer.id, item_type: group_transfer.model_name.to_s)
    end
    remove_column :group_subscriptions, :old_group_id
  end

  def down
    add_column :group_subscriptions, :old_group_id, :integer
    GroupTransfer.ordered.find_each do |group_transfer|
      group = Group.with_deleted.find_by(id: group_transfer.old_group_id)
      next unless group
      group_subscription = group_transfer.group_subscription
      group_subscription.update_column(:old_group_id, group.id)
      ChangeGroupOrder.where(item_id: group_transfer.id, item_type: group_transfer.model_name.to_s).update_all(item_id: group_subscription.id, item_type: group_subscription.model_name.to_s) if group_subscription
    end
  end
end
