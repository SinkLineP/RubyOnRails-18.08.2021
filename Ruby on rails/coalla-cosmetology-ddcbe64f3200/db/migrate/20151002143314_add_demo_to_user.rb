class AddDemoToUser < ActiveRecord::Migration
  def change
    add_column :users, :demo, :boolean, null: false, default: false
  end
end
