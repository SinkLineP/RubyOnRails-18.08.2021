class AddModuleGroupToGroupSubscription < ActiveRecord::Migration
  def change
    add_column :group_subscriptions, :created_from_module, :boolean, null: false, default: false
    add_reference :group_subscriptions, :module_group, index: true
    add_foreign_key :group_subscriptions, :module_groups
  end
end
