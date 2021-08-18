class AddFieldsToGroupSubscription < ActiveRecord::Migration
  def change
    change_table :group_subscriptions do |t|
      t.references :education_form, index: true, foreign_key: true
      t.references :discount, index: true, foreign_key: true
      t.float :price, null: false, default: 0
      t.text :payer
      t.text :amocrm_id
      t.text :amocrm_url
    end
  end
end