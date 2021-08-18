class AddNearestGroupToCourses < ActiveRecord::Migration
  def change
    add_reference :courses, :nearest_group, index: true
    add_foreign_key :courses, :groups, column: :nearest_group_id
    add_column :courses, :nearest_education_day, :date, index: true
  end
end
