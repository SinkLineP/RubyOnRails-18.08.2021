class CreateLectures < ActiveRecord::Migration
  def change
    create_table :lectures do |t|
      t.text :description
      t.integer :days
      t.references :block
      t.index :block_id
      t.foreign_key :blocks
      t.integer :position
      t.index :position

      t.timestamps null: false
    end
  end
end
