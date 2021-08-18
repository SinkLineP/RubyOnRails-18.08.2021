class AddItecToSubscriptions < ActiveRecord::Migration
  def change
    add_column :group_subscriptions, :itec, :text
  end
end
