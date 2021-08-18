class AddHideTutorialToUsers < ActiveRecord::Migration
  def change
    add_column :users, :hide_tutorial, :boolean, null: false, default: false
  end
end
