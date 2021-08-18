class CreatePractices < ActiveRecord::Migration
  def change
    create_table :practices do |t|
      t.datetime :begin_on, null: false
      t.datetime :end_on
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.belongs_to :group, foreign_key: true, null: false, index: true
      t.timestamps
    end
  end
end