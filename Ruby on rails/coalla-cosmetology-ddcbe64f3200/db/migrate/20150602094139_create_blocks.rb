class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.text :name, null: false
      t.boolean :active, null: false, default: false

      t.index :name
      t.index :active

      t.references :course
      t.foreign_key :courses
      t.index :course_id

      t.timestamps null: false
    end
  end
end
