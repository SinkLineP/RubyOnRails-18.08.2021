class CreateScheduleItems < ActiveRecord::Migration
  def change
    create_table :schedule_items do |t|
      t.references :classroom, index: true, foreign_key: true
      t.datetime :begin_at
      t.datetime :end_at
      t.date :day
      t.references :work, index: true, foreign_key: true
      t.integer :work_index, null: false, default: 0
      t.references :instructor, index: true, unique: true
      t.foreign_key :users, column: :instructor_id
      t.boolean :approved, null: false, default: false

      t.timestamps null: false
    end
  end
end
