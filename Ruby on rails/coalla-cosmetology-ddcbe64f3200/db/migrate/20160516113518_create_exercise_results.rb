class CreateExerciseResults < ActiveRecord::Migration
  def change
    create_table :exercise_results do |t|
      t.text :text
      t.text :parent_text
      t.integer :mark
      t.references :exercise, index: true, foreign_key: true
      t.references :student_work_result, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
