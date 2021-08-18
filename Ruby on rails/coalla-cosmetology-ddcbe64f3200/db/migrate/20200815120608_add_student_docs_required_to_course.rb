class AddStudentDocsRequiredToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :student_docs_required, :boolean, null: false, default: true
  end
end
