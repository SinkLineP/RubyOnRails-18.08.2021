class AddColumnsToSubscription < ActiveRecord::Migration
  def change
    change_table :group_subscriptions do |t|
      t.text :practice
      t.references :practice_basis, index: true, foreign_key: true
      t.text :payer_type
    end
  end
end
