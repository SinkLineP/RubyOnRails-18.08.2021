class AddDoubleCreatedToGroupSubscriptions < ActiveRecord::Migration
  def change
    add_column :group_subscriptions, :double_created, :boolean, null: false, default: false
  end
end
