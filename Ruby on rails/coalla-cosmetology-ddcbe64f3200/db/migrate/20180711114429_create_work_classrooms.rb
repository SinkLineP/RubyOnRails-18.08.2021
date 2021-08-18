class CreateWorkClassrooms < ActiveRecord::Migration
  def change
    create_table :work_classrooms do |t|
      t.references :work, index: true, foreign_key: true
      t.references :classroom, index: true, foreign_key: true
      t.index [:work_id, :classroom_id], unique: true

      t.timestamps null: false
    end
  end
end
