class CreateCourseInstructors < ActiveRecord::Migration
  def change
    create_table :course_instructors do |t|
      t.references :instructor, index: true
      t.foreign_key :users, column: :instructor_id
      t.references :course, index: true, foreign_key: true
      t.integer :position, null: false, default: 0, index: true

      t.timestamps null: false
    end
  end
end
