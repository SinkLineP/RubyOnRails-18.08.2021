class CreatePostCategoryLinks < ActiveRecord::Migration
  def change
    create_table :post_category_links do |t|
      t.references :post_category, index: true
      t.foreign_key :post_categories
      t.references :post, index: true
      t.foreign_key :posts

      t.timestamps null: false
    end
  end
end
