# == Schema Information
#
# Table name: survey_responses
#
#  id                    :integer          not null, primary key
#  total_time            :integer
#  surveymonkey_id       :string
#  ip                    :string
#  analyze_url           :text
#  modified_at           :datetime
#  group_subscription_id :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_survey_responses_on_group_subscription_id  (group_subscription_id)
#

class SurveyResponse < ActiveRecord::Base
  belongs_to :group_subscription, inverse_of: :survey_responses
  has_many :survey_answers,
           -> { order(:created_at) },
           inverse_of: :survey_response,
           dependent: :destroy

  scope :ordered, -> { order(modified_at: :desc) }
end
