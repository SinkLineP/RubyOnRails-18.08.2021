class CreateCourseDocuments < ActiveRecord::Migration
  def change
    create_table :course_documents do |t|
      t.references :course, index: true, foreign_key: true
      t.references :education_level, index: true, foreign_key: true
      t.references :education_document, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
