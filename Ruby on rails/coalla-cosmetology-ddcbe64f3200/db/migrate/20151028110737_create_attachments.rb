class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.text :item
      t.references :letter, index: true
      t.foreign_key :letters

      t.timestamps null: false
    end
  end
end
