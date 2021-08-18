class AddLectionAndVideoLinkToLecture < ActiveRecord::Migration
  def change
    change_table :lectures do |t|
      t.text :lecture_link
      t.text :video_link
    end
  end
end
