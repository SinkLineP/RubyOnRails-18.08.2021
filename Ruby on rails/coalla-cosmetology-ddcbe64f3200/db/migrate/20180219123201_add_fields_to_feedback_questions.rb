class AddFieldsToFeedbackQuestions < ActiveRecord::Migration
  def change
    change_table :feedback_questions do |t|
      t.text :student_name
      t.text :groups
      t.text :phone
    end
  end
end
