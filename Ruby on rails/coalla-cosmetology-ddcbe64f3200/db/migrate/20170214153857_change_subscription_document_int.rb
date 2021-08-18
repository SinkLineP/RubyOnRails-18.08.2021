class ChangeSubscriptionDocumentInt < ActiveRecord::Migration
  def change
    change_column :subscription_documents, :registration_number, :integer, limit: 8
  end
end
