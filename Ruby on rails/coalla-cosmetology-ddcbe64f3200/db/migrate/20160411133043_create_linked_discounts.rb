class CreateLinkedDiscounts < ActiveRecord::Migration
  def change
    create_table :linked_discounts do |t|
      t.references :parent, index: true
      t.references :discount, index: true, foreign_key: true
      t.foreign_key :discounts, column: :parent_id
      t.index [:parent_id, :discount_id], unique: true

      t.timestamps null: false
    end
  end
end
