class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.text :type, null: false

      t.references :instructor, index: true
      t.foreign_key :users, column: :instructor_id

      t.references :student, index: true
      t.foreign_key :users, column: :student_id

      t.references :task, foreign_key: true
      t.index :task_id

      t.text :status, null: false

      t.text :answer

      t.boolean :passed, null: false, default: false
      t.integer :mark
      t.datetime :marked_at

      t.timestamps null: false
    end

    create_table :result_file_items do |t|
      t.text :file

      t.references :result, foreign_key: true
      t.index :result_id

      t.integer :position
      t.timestamps
    end

    create_table :result_test_items do |t|
      t.references :result, foreign_key: true
      t.index :result_id

      t.references :question_answer, foreign_key: true
      t.index :question_answer_id

      t.timestamps
    end

    create_table :result_connection_items do |t|
      t.references :result, foreign_key: true
      t.index :result_id

      t.references :column, foreign_key: true
      t.index :column_id

      t.references :column_variant, foreign_key: true
      t.index :column_variant_id

      t.timestamps
    end

  end
end
