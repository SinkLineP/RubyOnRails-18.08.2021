class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.text :type
      t.text :title
      t.text :slug
      t.text :announce
      t.text :main_image
      t.text :main_image_title
      t.text :preview_image
      t.text :preview_announce
      t.text :content
      t.boolean :published, null: false, default: false
      t.timestamps
    end
  end
end
