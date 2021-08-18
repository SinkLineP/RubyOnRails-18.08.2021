class AddScheduledToWorkingOffList < ActiveRecord::Migration
  def change
    add_column :working_off_lists, :scheduled, :boolean, null: false, default: false
  end
end
