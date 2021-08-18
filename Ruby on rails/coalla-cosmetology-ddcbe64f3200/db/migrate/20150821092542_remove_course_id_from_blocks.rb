class RemoveCourseIdFromBlocks < ActiveRecord::Migration
  def up
    Block.where.not(course_id: nil).find_each do |block|
      CourseBlock.create!(course_id: block.course_id, block_id: block.id)
    end

    remove_column :blocks, :course_id
    remove_column :blocks, :position
  end

  def down
    add_reference :blocks, :course
    add_foreign_key :blocks, :courses
    add_column :blocks, :position, :integer, null: false, default: 0

    CourseBlock.find_each do |course_block|
      course_block.block.update_column(:course_id, course_block.course_id)
    end

    CourseBlock.delete_all
  end
end
