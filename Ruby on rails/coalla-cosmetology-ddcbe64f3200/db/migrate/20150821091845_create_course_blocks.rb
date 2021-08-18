class CreateCourseBlocks < ActiveRecord::Migration
  def change
    create_table :course_blocks do |t|
      t.references :block, index: true
      t.foreign_key :blocks
      t.references :course, index: true
      t.foreign_key :courses
      t.integer :position, null: false, default: 0

      t.timestamps null: false
    end
  end
end
