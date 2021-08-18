class CreateUsedTimes < ActiveRecord::Migration
  def change
    create_table :used_times do |t|
      t.date :date, index: true
      t.time :time

      t.timestamps null: false
    end
  end
end
