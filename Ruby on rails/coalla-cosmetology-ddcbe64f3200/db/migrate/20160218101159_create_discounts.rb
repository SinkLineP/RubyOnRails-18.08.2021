class CreateDiscounts < ActiveRecord::Migration
  def change
    create_table :discounts do |t|
      t.text :title
      t.text :type
      t.float :value, null: false, default: 0

      t.timestamps null: false
    end
  end
end
