class AddPositionToBlock < ActiveRecord::Migration
  def change
    add_column :blocks, :position, :integer
    add_index :blocks, :position
  end
end
