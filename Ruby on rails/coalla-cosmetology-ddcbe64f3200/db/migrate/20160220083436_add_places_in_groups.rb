class AddPlacesInGroups < ActiveRecord::Migration
  def change
    add_column :groups, :distances_place, :integer, default: 0, null: false
    add_column :groups, :distances_count, :integer, default: 0, null: false
    add_column :groups, :academics_place, :integer, default: 0, null: false
    add_column :groups, :academics_count, :integer, default: 0, null: false
  end
end
