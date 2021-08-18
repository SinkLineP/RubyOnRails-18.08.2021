class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.text :uid, null: false, index: true
      t.text :provider, null: false
      t.text :access_token, null: false
      t.text :access_token_secret
      t.text :url, null: false
      t.references :user, index: true
      t.foreign_key :users

      t.timestamps
    end
  end
end
