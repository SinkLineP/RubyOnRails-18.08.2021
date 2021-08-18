class CreateCourseRecalls < ActiveRecord::Migration
  def change
    create_table :course_recalls do |t|
      t.references :recall, index: true, foreign_key: true
      t.references :course, index: true, foreign_key: true
      t.integer :position, null: false, default: 0, index: true

      t.timestamps null: false
    end
  end
end
