class CreateFeedbackQuestions < ActiveRecord::Migration
  def change
    create_table :feedback_questions do |t|
      t.text :type, null: false
      t.references :student, index: true
      t.foreign_key :users, column: :student_id
      t.references :instructor, :index
      t.foreign_key :users, column: :instructor_id
      t.text :text

      t.timestamps null: false
    end
  end
end
