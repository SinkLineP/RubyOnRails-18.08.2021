class AddRequestToCashReciept < ActiveRecord::Migration
  def change
    add_column :cash_receipts, :request, :text
  end
end
