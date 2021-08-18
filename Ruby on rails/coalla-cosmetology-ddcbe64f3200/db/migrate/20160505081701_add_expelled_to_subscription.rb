class AddExpelledToSubscription < ActiveRecord::Migration
  def change
    add_column :group_subscriptions, :expelled, :boolean, null: false, default: false
  end
end
