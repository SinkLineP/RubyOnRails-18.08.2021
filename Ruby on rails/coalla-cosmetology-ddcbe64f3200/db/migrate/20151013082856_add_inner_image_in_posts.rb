class AddInnerImageInPosts < ActiveRecord::Migration
  def change
    add_column :posts, :inner_image, :text
    Post.find_each{|p| p.update!(inner_image: File.open(p.announcement_image.path)) }
  end
end
