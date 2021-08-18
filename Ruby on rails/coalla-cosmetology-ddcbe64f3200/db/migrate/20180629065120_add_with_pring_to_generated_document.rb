class AddWithPringToGeneratedDocument < ActiveRecord::Migration
  def change
    add_column :generated_documents, :with_print, :boolean, null: false, default: false
  end
end
