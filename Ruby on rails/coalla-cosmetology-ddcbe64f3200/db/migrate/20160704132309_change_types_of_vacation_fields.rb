class ChangeTypesOfVacationFields < ActiveRecord::Migration
  def change
    change_column :group_subscriptions, :vacation_end_on, :date
    change_column :group_subscriptions, :vacation_begin_on, :date
  end
end
