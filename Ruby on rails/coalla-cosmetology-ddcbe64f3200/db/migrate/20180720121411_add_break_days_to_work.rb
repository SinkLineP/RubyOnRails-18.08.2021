class AddBreakDaysToWork < ActiveRecord::Migration
  def change
    add_column :works, :break_days, :integer, null: false, default: 0
  end
end
