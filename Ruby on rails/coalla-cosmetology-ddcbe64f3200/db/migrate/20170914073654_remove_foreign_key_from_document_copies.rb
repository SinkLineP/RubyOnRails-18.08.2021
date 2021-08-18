class RemoveForeignKeyFromDocumentCopies < ActiveRecord::Migration
  def change
    remove_foreign_key :document_copies, column: :item_id
  end
end
