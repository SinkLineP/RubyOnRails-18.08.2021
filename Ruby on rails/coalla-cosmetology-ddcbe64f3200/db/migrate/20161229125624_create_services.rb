class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.text :title
      t.string :price
      t.string :units

      t.timestamps null: false
    end
  end
end
