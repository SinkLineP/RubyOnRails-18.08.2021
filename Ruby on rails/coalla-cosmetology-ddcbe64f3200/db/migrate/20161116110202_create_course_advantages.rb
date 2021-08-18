class CreateCourseAdvantages < ActiveRecord::Migration
  def change
    create_table :course_advantages do |t|
      t.references :advantage, index: true, foreign_key: true
      t.references :course, index: true, foreign_key: true
      t.integer :position, null: false, default: 0, index: true

      t.timestamps null: false
    end
  end
end
