class CreateCourseLinks < ActiveRecord::Migration
  def change
    create_table :course_links do |t|
      t.text :link
      t.references :course, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
