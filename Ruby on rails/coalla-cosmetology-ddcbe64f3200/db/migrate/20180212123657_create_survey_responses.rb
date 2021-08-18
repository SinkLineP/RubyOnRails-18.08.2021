class CreateSurveyResponses < ActiveRecord::Migration
  def change
    create_table :survey_responses do |t|
      t.integer :total_time
      t.string :surveymonkey_id
      t.string :ip
      t.text :analyze_url
      t.datetime :modified_at
      t.references :group_subscription, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
