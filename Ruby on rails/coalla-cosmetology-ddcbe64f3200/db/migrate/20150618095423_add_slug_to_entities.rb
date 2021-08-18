class AddSlugToEntities < ActiveRecord::Migration
  def change
    add_column :posts, :slug, :text
    add_column :post_categories, :slug, :text
  end
end
