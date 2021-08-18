class AddScheduledToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :scheduled, :boolean, null: false, default: false
  end
end
