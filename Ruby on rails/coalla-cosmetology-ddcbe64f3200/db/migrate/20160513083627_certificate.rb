class Certificate < ActiveRecord::Migration
  def change
    add_column :subscription_documents, :document, :text
    add_column :subscription_documents, :first_appendix, :text
    add_column :subscription_documents, :second_appendix, :text
  end
end
