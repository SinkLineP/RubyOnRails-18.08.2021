class CreateHolidays < ActiveRecord::Migration
  def change
    create_table :holidays do |t|
      t.integer :year, null: false
      t.date :day, null: false
      t.index :year
      t.index :day, unique: true

      t.timestamps null: false
    end
  end
end
