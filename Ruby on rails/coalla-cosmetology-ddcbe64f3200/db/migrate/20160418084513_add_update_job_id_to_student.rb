class AddUpdateJobIdToStudent < ActiveRecord::Migration
  def change
    add_column :users, :update_job_id, :integer
  end
end
