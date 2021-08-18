class CreateGroupPrices < ActiveRecord::Migration
  def change
    create_table :group_prices do |t|
      t.integer :amount, null: false, default: 0
      t.text :payments_text, null: false
      t.text :description
      t.belongs_to :group, foreign_key: true, index: true
      t.timestamps
    end
  end
end
