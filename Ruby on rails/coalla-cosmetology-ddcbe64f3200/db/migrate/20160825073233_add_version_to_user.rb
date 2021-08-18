class AddVersionToUser < ActiveRecord::Migration
  def change
    add_column :users, :version, :integer, null: false, default: 0
  end
end