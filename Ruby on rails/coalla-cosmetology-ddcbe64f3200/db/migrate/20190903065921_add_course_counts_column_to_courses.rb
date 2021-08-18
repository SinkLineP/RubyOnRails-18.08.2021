class AddCourseCountsColumnToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :course_counts, :integer, null: false, default: 0
  end
end
