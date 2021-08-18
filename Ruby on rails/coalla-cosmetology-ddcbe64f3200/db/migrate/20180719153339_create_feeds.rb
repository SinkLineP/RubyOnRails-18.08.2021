class CreateFeeds < ActiveRecord::Migration
  def up
    create_table :feeds do |t|
      t.string :name

      t.timestamps null: false
    end

    Feed.create!(name: :mindbox)
  end

  def down
    drop_table :feeds
  end
end
