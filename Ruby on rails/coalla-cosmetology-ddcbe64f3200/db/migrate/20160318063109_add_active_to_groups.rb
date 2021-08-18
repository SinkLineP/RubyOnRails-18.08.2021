class AddActiveToGroups < ActiveRecord::Migration
  def up
    add_column :groups, :active, :boolean, null: false, default: false

    Group.update_all(active: true)
  end

  def down
    remove_column :groups, :active
  end
end
