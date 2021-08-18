class SubscriptionDocumentAddFields < ActiveRecord::Migration
  def change
    add_column :subscription_documents, :decline_first_name, :boolean, null: false, default: false
    add_column :subscription_documents, :decline_last_name, :boolean, null: false, default: false
    add_column :subscription_documents, :decline_middle_name, :boolean, null: false, default: false
  end
end
