class AddFileFieldToFeedbackQuestions < ActiveRecord::Migration
  def change
    add_column :feedback_questions, :file, :text
  end
end
