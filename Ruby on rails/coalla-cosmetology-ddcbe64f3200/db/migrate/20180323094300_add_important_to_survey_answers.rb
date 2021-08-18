class AddImportantToSurveyAnswers < ActiveRecord::Migration
  def change
    add_column :survey_answers, :important, :boolean, null: false, default: false
  end
end
