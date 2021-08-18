class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.text :text
      t.integer :max_mark
      t.integer :index
      t.references :work, index: true, foreign_key: true
      t.references :parent, index: true
      t.foreign_key :exercises, column: :parent_id

      t.timestamps null: false
    end
  end
end
