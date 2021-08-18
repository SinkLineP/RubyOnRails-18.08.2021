# == Schema Information
#
# Table name: survey_answers
#
#  id                 :integer          not null, primary key
#  question           :text
#  answer             :text
#  survey_response_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  important          :boolean          default(FALSE), not null
#
# Indexes
#
#  index_survey_answers_on_survey_response_id  (survey_response_id)
#

class SurveyAnswer < ActiveRecord::Base
  belongs_to :survey_response, inverse_of: :survey_answers

  scope :with_important,  -> { where(important: true) }
end
