class CreateCourseSkills < ActiveRecord::Migration
  def change
    create_table :course_skills do |t|
      t.references :skill, index: true, foreign_key: true
      t.references :course, index: true, foreign_key: true
      t.integer :position, null: false, default: 0, index: true

      t.timestamps null: false
    end
  end
end
