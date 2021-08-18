class RenameOrderFields < ActiveRecord::Migration
  def change
    rename_column :orders, :through_the_basket, :cart
    rename_column :orders, :paid_all, :full
    remove_column :orders, :automatic_discount_id, :integer
  end
end
