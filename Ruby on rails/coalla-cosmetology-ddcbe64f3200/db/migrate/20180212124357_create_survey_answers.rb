class CreateSurveyAnswers < ActiveRecord::Migration
  def change
    create_table :survey_answers do |t|
      t.text :question
      t.text :answer
      t.references :survey_response, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
