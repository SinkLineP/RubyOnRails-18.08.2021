class CreatePromoCodes < ActiveRecord::Migration
  def change
    create_table :promo_codes do |t|
      t.text :code
      t.references :discount, index: true, foreign_key: true
      t.date :end_date
      t.boolean :reusable, default: false
      t.boolean :extinguished, default: false
      t.timestamps
    end
  end
end
