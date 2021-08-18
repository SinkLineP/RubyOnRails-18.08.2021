class AddDocumentSectionsToDocument < ActiveRecord::Migration
  def change
    change_table :documents do |t|
      t.references :document_section, index: true
    end
  end
end
