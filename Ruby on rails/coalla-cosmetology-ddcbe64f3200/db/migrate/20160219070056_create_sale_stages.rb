class CreateSaleStages < ActiveRecord::Migration
  def change
    create_table :sale_stages do |t|
      t.text :title, null: false

      t.timestamps null: false
    end
  end
end
