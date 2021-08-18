class AddFieldsToGroupPrice < ActiveRecord::Migration
  def change
    add_column :group_prices, :early_booking, :boolean, default: false
    add_column :group_prices, :bank_installment, :boolean, default: false
    add_column :group_prices, :bank_installment_months, :integer, default: 0
  end
end
