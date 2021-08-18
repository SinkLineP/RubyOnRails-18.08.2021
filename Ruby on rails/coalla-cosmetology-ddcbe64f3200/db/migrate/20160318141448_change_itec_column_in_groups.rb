class ChangeItecColumnInGroups < ActiveRecord::Migration
  def change
    remove_column :groups, :itec
    add_column :groups, :itec, :datetime
  end
end
