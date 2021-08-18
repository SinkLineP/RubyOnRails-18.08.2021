class CreateInstructorVacations < ActiveRecord::Migration
  def change
    create_table :instructor_vacations do |t|
      t.references :instructor, index: true
      t.foreign_key :users, column: :instructor_id
      t.date :begin_on, null: false
      t.date :end_on, null: false

      t.timestamps null: false
    end
  end
end
