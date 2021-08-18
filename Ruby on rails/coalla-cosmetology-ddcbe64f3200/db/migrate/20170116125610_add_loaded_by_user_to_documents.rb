class AddLoadedByUserToDocuments < ActiveRecord::Migration
  def change
    add_column :document_copies, :loaded_by_user, :boolean, default: false
    add_column :student_documents, :loaded_by_user, :boolean, default: false
  end
end
