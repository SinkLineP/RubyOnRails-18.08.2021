class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.text :author
      t.text :name
      t.integer :book_category_id
      t.text :description
      t.integer :code
      t.text :cover

      t.index :book_category_id
      t.foreign_key :book_categories

      t.timestamps null: false
    end
  end
end
