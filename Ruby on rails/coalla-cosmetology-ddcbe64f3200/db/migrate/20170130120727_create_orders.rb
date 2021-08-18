class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :user, index: true, foreign_key: true
      t.references :promo_code, index: true, foreign_key: true
      t.references :automatic_discount, index: true, foreign_key: true
      t.timestamps
    end
  end
end
