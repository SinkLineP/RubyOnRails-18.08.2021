class AddResponsibleNameToGroupSubscription < ActiveRecord::Migration
  def change
    add_column :group_subscriptions, :responsible_name, :text
  end
end
