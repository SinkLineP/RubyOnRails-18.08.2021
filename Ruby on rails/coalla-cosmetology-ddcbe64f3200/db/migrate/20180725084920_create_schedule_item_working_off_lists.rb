class CreateScheduleItemWorkingOffLists < ActiveRecord::Migration
  def change
    create_table :schedule_item_working_off_lists do |t|
      t.references :schedule_item, index: true, foreign_key: true
      t.references :working_off_list, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
