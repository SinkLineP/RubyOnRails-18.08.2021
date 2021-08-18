class CreateInstructorWorks < ActiveRecord::Migration
  def change
    create_table :instructor_works do |t|
      t.references :instructor, index: true
      t.foreign_key :users, column: :instructor_id
      t.references :work, index: true, foreign_key: true
      t.index [:instructor_id, :work_id], unique: true

      t.timestamps null: false
    end
  end
end
