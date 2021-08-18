class CreateStudentWorkResults < ActiveRecord::Migration
  def change
    create_table :student_work_results do |t|
      t.references :work_result, index: true, foreign_key: true
      t.references :student, index: true
      t.foreign_key :users, column: :student_id
      t.boolean :absent, null: false, default: true
      t.boolean :passed, null: false, default: false
      t.integer :content
      t.integer :typography
      t.integer :protection
      t.integer :total
      t.integer :presence
      t.integer :customer_care
      t.integer :hygiene

      t.timestamps null: false
    end
  end
end
