class AddDateColumnsInGroups < ActiveRecord::Migration
  def up
    add_column :groups, :begin_on, :datetime
    add_column :groups, :end_on, :datetime

    Group.update_all(begin_on: Date.today, end_on: Date.today)

    change_column_null :groups, :begin_on, false
    change_column_null :groups, :end_on, false
  end

  def down
    remove_columns :groups, :begin_on, :end_on
  end
end
