class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :title
      t.text :announcement
      t.text :text
      t.boolean :published, null: false, default: false

      t.timestamps
    end
  end
end
