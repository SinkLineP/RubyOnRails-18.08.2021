class CreateCourseWorks < ActiveRecord::Migration
  def change
    create_table :course_works do |t|
      t.integer :hours
      t.boolean :main, null: false, default: false
      t.references :course, index: true, foreign_key: true
      t.references :work, index: true, foreign_key: true
      t.references :lecture, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
