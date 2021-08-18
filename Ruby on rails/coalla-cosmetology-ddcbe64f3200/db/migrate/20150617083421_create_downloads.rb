class CreateDownloads < ActiveRecord::Migration
  def change
    create_table :downloads do |t|
      t.text :file

      t.references :lecture
      t.index :lecture_id
      t.foreign_key :lectures

      t.integer :position
      t.index [:lecture_id, :position]

      t.timestamps null: false
    end
  end
end
