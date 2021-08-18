class AddHoursAndProgramNameForCourseDocument < ActiveRecord::Migration
  def change
    add_column :course_documents, :academic_hours, :integer
    add_column :course_documents, :program_name, :text
  end
end
