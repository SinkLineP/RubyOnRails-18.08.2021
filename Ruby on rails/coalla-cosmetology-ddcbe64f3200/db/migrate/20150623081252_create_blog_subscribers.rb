class CreateBlogSubscribers < ActiveRecord::Migration
  def change
    create_table :blog_subscribers do |t|
      t.text :email, null: false
      t.index :email, unique: true
      t.references :user, index: true
      t.foreign_key :users

      t.timestamps null: false
    end
  end
end
