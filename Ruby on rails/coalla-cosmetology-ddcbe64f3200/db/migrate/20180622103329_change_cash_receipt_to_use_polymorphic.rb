class ChangeCashReceiptToUsePolymorphic < ActiveRecord::Migration
  def change
    rename_column :cash_receipts, :order_id, :item_id
    add_column :cash_receipts, :item_type, :string, default: 'Order'
  end
end
