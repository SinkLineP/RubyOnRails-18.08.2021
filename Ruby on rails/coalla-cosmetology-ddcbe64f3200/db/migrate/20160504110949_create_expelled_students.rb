class CreateExpelledStudents < ActiveRecord::Migration
  def change
    create_table :expelled_students do |t|
      t.integer :hours, null: false, default: 0
      t.references :expulsion, index: true, foreign_key: true
      t.references :student, index: true
      t.foreign_key :users, column: :student_id

      t.timestamps null: false
    end
  end
end
