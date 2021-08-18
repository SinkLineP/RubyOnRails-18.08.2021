class AddVideoPreview < ActiveRecord::Migration
  def change
    add_column :recalls, :video_image, :text
  end
end
