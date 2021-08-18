class AddErgonomicToStudentWorkResults < ActiveRecord::Migration
  def change
    add_column :student_work_results, :ergonomic, :integer
  end
end
