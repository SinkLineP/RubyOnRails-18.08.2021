class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.text :title
      t.references :course, index: true
      t.foreign_key :courses
      t.references :instructor, index: true
      t.foreign_key :users, column: :instructor_id

      t.timestamps null: false
    end
  end
end
