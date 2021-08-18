class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :group_subscription, index: true, foreign_key: true
      t.float :amount, null: false, default: 0
      t.date :payed_on

      t.timestamps null: false
    end
  end
end
