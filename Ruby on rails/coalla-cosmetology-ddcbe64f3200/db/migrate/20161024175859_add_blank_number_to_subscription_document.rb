class AddBlankNumberToSubscriptionDocument < ActiveRecord::Migration
  def change
    add_column :subscription_documents, :blank_number, :string
  end
end
