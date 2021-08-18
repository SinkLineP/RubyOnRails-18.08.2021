class CreateAutomaticDiscounts < ActiveRecord::Migration
  def change
    create_table :automatic_discounts do |t|
      t.text :name
      t.references :discount, foreign_key: true, index: true
      t.boolean :enabled, default: false
      t.timestamps
    end
  end
end
