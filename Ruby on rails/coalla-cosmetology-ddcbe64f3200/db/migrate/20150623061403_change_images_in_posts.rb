class ChangeImagesInPosts < ActiveRecord::Migration
  def change
    rename_column :posts, :image, :announcement_image
    add_column :posts, :slider_image, :text
  end
end
