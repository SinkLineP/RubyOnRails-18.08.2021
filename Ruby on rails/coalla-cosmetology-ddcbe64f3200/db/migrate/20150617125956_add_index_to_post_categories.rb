class AddIndexToPostCategories < ActiveRecord::Migration
  def change
    add_index :post_categories, :title, unique: true
  end
end
