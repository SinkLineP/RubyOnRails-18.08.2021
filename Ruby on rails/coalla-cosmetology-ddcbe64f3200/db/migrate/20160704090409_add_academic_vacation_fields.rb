class AddAcademicVacationFields < ActiveRecord::Migration
  def change
    change_table :group_subscriptions do |t|
      t.boolean :academic_vacation, null: false, default: false
      t.datetime :vacation_begin_on
      t.datetime :vacation_end_on
    end
  end
end
