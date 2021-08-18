class CreateCourseSpecialities < ActiveRecord::Migration
  def change
    create_table :course_specialities do |t|
      t.references :course, index: true, foreign_key: true
      t.references :speciality, index: true, foreign_key: true
      t.integer :position, index: true, null: false, default: 0

      t.timestamps null: false
    end
  end
end
