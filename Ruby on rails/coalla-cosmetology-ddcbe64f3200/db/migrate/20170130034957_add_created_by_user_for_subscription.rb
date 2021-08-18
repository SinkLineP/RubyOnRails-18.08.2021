class AddCreatedByUserForSubscription < ActiveRecord::Migration
  def change
    add_column :group_subscriptions, :created_by_user, :boolean, default: false
  end
end
