class CreatePaymentRequisites < ActiveRecord::Migration
  def change
    create_table :payment_requisites do |t|
      t.references :group_subscription, index: true, foreign_key: true
      t.text :name
      t.text :address
      t.integer :inn
      t.integer :kpp
      t.integer :account
      t.integer :bik
      t.text :bank
      t.integer :correspondent_account
      t.text :phone
      t.text :email

      t.timestamps null: false
    end
  end
end
