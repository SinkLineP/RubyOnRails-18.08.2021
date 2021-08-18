class CreateBookCategories < ActiveRecord::Migration
  def change
    create_table :book_categories do |t|
      t.text :name
      t.index :name, unique: true

      t.timestamps null: false
    end
  end
end
