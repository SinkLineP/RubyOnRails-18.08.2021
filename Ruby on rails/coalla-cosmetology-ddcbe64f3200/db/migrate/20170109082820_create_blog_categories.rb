class CreateBlogCategories < ActiveRecord::Migration
  def change
    create_table :blog_categories do |t|
      t.references :category, index: true, foreign_key: true
      t.references :article, index: true, foreign_key: true
      t.timestamps
    end
  end
end
