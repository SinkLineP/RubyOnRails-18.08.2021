class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :access_token, null: true
      t.references :user, foreign_key: true, index: true, null: false

      t.timestamps
    end

    add_index :api_keys, :access_token, unique: true
    add_index :api_keys, [:access_token, :user_id], unique: true
  end
end
