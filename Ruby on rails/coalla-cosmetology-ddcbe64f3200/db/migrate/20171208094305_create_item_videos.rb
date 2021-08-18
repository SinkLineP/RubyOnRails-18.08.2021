class CreateItemVideos < ActiveRecord::Migration
  def change
    create_table :item_videos do |t|
      t.references :uploaded_video, foreign_key: true
      t.references :item, polymorphic: true
      t.timestamps null: false
    end
  end
end
