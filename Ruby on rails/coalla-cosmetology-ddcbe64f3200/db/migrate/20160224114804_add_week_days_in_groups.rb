class AddWeekDaysInGroups < ActiveRecord::Migration
  def change
    add_column :groups, :week_days, :text
  end
end
