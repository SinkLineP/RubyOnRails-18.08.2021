class CreateCourseEducationDocuments < ActiveRecord::Migration
  def change
    create_table :course_education_documents do |t|
      t.references :education_document, index: true, foreign_key: true
      t.references :course, index: true, foreign_key: true
      t.integer :position, null: false, default: 0, index: true

      t.timestamps null: false
    end
  end
end
