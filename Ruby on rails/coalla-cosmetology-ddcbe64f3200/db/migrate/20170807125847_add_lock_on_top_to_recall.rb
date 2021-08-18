class AddLockOnTopToRecall < ActiveRecord::Migration
  def change
    add_column :recalls, :lock_on_top, :boolean, default: false
  end
end
