class AddThroughTheBasket < ActiveRecord::Migration
  def change
    add_column :orders, :through_the_basket, :boolean, default: false
    add_column :orders, :paid_all, :boolean, default: false
  end
end
