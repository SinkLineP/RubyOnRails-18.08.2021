class CreatePostCategories < ActiveRecord::Migration
  def change
    create_table :post_categories do |t|
      t.text :title

      t.timestamps null: false
    end
  end
end
