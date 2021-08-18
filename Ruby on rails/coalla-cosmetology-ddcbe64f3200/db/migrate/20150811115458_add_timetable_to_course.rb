class AddTimetableToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :timetable, :text
  end
end
