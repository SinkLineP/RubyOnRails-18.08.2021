class AddClonedToBlock < ActiveRecord::Migration
  def change
    add_column :blocks, :cloned, :boolean, null: false, default: false
  end
end
