class AddUpdateJobIdToGroupSubsctiptions < ActiveRecord::Migration
  def change
    add_column :group_subscriptions, :update_job_id, :integer
  end
end
