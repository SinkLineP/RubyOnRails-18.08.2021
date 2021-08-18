class CreateUploadedVideos < ActiveRecord::Migration
  def change
    create_table :uploaded_videos do |t|
      t.text :title, null: false
      t.text :preview_image
      t.text :file
      t.timestamps null: false
    end
  end
end
