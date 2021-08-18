class AddPositionToBlogCourses < ActiveRecord::Migration
  def change
    add_column :blog_courses, :position, :integer, null: false, default: 0
  end
end
