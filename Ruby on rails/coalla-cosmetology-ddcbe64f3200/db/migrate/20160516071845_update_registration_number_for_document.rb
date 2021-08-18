class UpdateRegistrationNumberForDocument < ActiveRecord::Migration
  def up
    SubscriptionDocument.where(registration_number: '').update_all(registration_number: nil)
    change_column :subscription_documents, :registration_number, 'integer USING CAST(registration_number AS integer)'
  end

  def down
    change_column :subscription_documents, :registration_number, :text
  end
end
