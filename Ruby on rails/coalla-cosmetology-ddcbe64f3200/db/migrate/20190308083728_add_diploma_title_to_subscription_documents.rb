class AddDiplomaTitleToSubscriptionDocuments < ActiveRecord::Migration
  def change
    add_column :subscription_documents, :diploma_title, :text
  end
end
