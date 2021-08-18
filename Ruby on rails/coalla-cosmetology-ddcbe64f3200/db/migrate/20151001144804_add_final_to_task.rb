class AddFinalToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :final, :boolean, null: false, default: false
  end
end
