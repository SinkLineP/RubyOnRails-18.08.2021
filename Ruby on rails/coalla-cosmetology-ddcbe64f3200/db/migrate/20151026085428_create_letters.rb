class CreateLetters < ActiveRecord::Migration
  def change
    create_table :letters do |t|
      t.text :folder, null: false
      t.text :subject
      t.text :body
      t.boolean :read, null: false, default: false
      t.datetime :sent_at, null: false
      t.references :student, index: true, null: false
      t.foreign_key :users, column: :student_id
      t.references :instructor, index: true, null: false
      t.foreign_key :users, column: :instructor_id

      t.timestamps null: false
    end
  end
end
