class AddOrderToPaymentLog < ActiveRecord::Migration
  def change
    change_table :payment_logs do |t|
      t.references :order, index: true
    end
  end
end
