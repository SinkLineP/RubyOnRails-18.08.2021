class CreateDocumentSections < ActiveRecord::Migration
  def change
    create_table :document_sections do |t|
      t.text :title, null: false
      t.timestamps
    end
  end
end
