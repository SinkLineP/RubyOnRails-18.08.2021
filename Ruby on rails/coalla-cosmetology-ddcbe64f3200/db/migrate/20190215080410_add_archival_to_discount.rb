class AddArchivalToDiscount < ActiveRecord::Migration
  def change
    add_column :discounts, :archival, :boolean, null: false, default: false
  end
end
