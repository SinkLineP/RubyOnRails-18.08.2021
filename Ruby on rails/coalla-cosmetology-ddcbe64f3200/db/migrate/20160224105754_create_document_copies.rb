class CreateDocumentCopies < ActiveRecord::Migration
  def change
    create_table :document_copies do |t|
      t.text :file
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
