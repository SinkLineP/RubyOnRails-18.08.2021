class CreateSubscriptionDocuments < ActiveRecord::Migration
  def change
    create_table :subscription_documents do |t|
      t.belongs_to :group_subscription, index: true, foreign_key: true, null: false
      t.belongs_to :education_document, index: true, foreign_key: true, null: false
      t.date :issued_at
      t.text :registration_number
      t.timestamps
    end
  end
end
