class AddUidToLetter < ActiveRecord::Migration
  def change
    add_column :letters, :uid, :integer
    add_column :letters, :message_id, :text, null: false

    add_index :letters, :message_id, unique: true
  end
end