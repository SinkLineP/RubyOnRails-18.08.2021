class CreateInstructorFaculties < ActiveRecord::Migration
  def change
    create_table :instructor_faculties do |t|
      t.references :instructor, index: true
      t.foreign_key :users, column: :instructor_id
      t.references :faculty, index: true, foreign_key: true
      t.integer :position, null: false, default: 0

      t.timestamps null: false
    end
  end
end
