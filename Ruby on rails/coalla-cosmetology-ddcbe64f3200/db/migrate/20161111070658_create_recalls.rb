class CreateRecalls < ActiveRecord::Migration
  def change
    create_table :recalls do |t|
      t.text :file
      t.text :video_link
      t.text :message, null: false
      t.text :author_name, null: false
      t.text :author_image
      t.timestamps
    end
  end
end
