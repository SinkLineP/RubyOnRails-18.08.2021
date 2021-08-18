class AddAbsenteeismFieldsToFeedbackQuestions < ActiveRecord::Migration
  def change
    change_table :feedback_questions do |t|
      t.text :work_title
      t.text :absent_dates
      t.text :new_dates
      t.text :working_off_type
    end
  end
end
