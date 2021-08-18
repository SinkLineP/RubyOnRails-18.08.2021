class AddPositionToCourseWorks < ActiveRecord::Migration
  def change
    add_column :course_works, :position, :integer, null: false, default: 0
  end
end