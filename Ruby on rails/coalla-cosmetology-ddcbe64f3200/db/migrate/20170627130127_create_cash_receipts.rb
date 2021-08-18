class CreateCashReceipts < ActiveRecord::Migration
  def change
    create_table :cash_receipts do |t|
      t.integer :code
      t.integer :uuid
      t.text :response
      t.references :order, index: true
      t.timestamps null: false
    end
  end
end
