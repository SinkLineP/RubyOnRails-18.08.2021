class AddLectureToFeedbackQuestion < ActiveRecord::Migration
  def change
    add_reference :feedback_questions, :lecture, index: true, foreign_key: true
  end
end
