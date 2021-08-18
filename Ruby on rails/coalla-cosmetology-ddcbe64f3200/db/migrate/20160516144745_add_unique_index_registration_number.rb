class AddUniqueIndexRegistrationNumber < ActiveRecord::Migration
  def change
    add_index :subscription_documents, :registration_number, unique: true
  end
end
