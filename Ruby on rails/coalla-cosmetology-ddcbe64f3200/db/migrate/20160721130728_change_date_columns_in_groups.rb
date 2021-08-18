class ChangeDateColumnsInGroups < ActiveRecord::Migration
  def change
    change_column :groups, :end_on, :date
    change_column :groups, :begin_on, :date

    Group.with_deleted.find_each{ |group| group.update(begin_on: group.begin_on + 1.day, end_on: group.end_on + 1.day) }
  end
end
