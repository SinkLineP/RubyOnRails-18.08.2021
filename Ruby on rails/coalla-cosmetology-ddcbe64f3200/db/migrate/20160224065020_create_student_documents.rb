class CreateStudentDocuments < ActiveRecord::Migration
  def change
    create_table :student_documents do |t|
      t.text :title
      t.text :document_type
      t.text :file
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
