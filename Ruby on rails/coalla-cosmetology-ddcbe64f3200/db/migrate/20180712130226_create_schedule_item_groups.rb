class CreateScheduleItemGroups < ActiveRecord::Migration
  def change
    create_table :schedule_item_groups do |t|
      t.references :schedule_item, index: true, foreign_key: true
      t.references :group, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
