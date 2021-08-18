class CreateOldUrls < ActiveRecord::Migration
  def change
    create_table :old_urls do |t|
      t.text :url, null: false
      t.text :new_url, null: false
      t.timestamps null: false
    end
    # removed
  end
end
