class AddIndexToGroupSubscription < ActiveRecord::Migration
  def change
    add_index :group_subscriptions, [:group_id, :student_id], unique: true
  end
end