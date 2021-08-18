class AddJwScriptToUploadVideos < ActiveRecord::Migration
  def change
    add_column :uploaded_videos, :jw_script, :text
  end
end
