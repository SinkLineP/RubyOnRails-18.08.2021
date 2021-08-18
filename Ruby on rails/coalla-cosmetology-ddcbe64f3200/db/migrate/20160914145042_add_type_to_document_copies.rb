class AddTypeToDocumentCopies < ActiveRecord::Migration
  def up
    add_column :document_copies, :item_type, :text
    DocumentCopy.update_all(item_type: User)
    change_column_null :document_copies, :item_type, false
    rename_column :document_copies, :user_id, :item_id
  end

  def down
    remove_column :document_copies, :item_type
    rename_column :document_copies, :item_id, :user_id
  end
end
