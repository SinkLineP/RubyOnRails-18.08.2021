class CreateEducationDocumentPictures < ActiveRecord::Migration
  def change
    create_table :education_document_pictures do |t|
      t.references :education_document, index: true, foreign_key: true
      t.text :image

      t.timestamps null: false
    end
  end
end