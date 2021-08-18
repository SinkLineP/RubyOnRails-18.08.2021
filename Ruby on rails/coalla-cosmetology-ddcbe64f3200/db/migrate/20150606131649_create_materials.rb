class CreateMaterials < ActiveRecord::Migration
  def change
    create_table :materials do |t|
      t.references :lecture
      t.index :lecture_id
      t.foreign_key :lectures

      t.text :name
      t.integer :time
      t.text :link
      t.boolean :required, default: false, null: false
      t.text :cover

      t.integer :position

      t.index :position

      t.timestamps null: false
    end
  end
end
