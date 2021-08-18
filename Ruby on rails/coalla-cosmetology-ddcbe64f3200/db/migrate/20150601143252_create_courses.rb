class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.text :name, null: false
      t.boolean :active, null: false, default: false

      t.timestamps null: false

      t.index :active
      t.index :name
    end
  end
end
