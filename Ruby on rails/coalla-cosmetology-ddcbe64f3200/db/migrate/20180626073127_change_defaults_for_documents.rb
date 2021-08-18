class ChangeDefaultsForDocuments < ActiveRecord::Migration
  def change
    change_column_default :subscription_documents, :decline_first_name, true
    change_column_default :subscription_documents, :decline_last_name, true
    change_column_default :subscription_documents, :decline_middle_name, true
  end
end
