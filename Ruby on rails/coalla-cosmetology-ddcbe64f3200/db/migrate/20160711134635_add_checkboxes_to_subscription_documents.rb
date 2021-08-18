class AddCheckboxesToSubscriptionDocuments < ActiveRecord::Migration
  def up
    add_column :subscription_documents, :ready_to_issue, :boolean, default: false
    add_column :subscription_documents, :issued, :boolean, default: false
  end

  def down
    remove_column :subscription_documents, :ready_to_issue
    remove_column :subscription_documents, :issued
  end
end
