require 'surveymonkey'

module Surveys
  class Responses

    def initialize(response_id)
      @response_id = response_id
      @client = ::SurveyMonkeyApi::Client.new
    end

    def create!
      response_details = @client.response_with_details(SURVEY_ID, @response_id)
      group_subscription = load_group_subscription!(response_details)
      survey_response = nil
      group_subscription.transaction do
        survey_response = build_survey_responce(response_details)
        survey_response.group_subscription_id = group_subscription.id
        build_survey_answers(response_details).each do |attributes|
          survey_response.survey_answers.build(attributes)
        end
        survey_response.save!
      end
      recommended_study_answer = build_survey_answers(response_details).first
      if recommended_study_answer[:answer] == "9" or recommended_study_answer[:answer] == "Крайне вероятно - 10"
        CosmetologyMailer.polling_result_send_mail(group_subscription.student).deliver
      end
      survey_response
    end

    private

    def fail!(message)
      raise UnprocessableDataException.new(message)
    end

    def load_group_subscription!(response_details)
      group_subscription_id = response_details['custom_variables'] && response_details['custom_variables']['gs']
      fail!('Group subscription id is empty') if group_subscription_id.blank?
      group_subscription = ::GroupSubscription.find(group_subscription_id)
      fail!("Group subscription with ID = #{group_subscription_id} not found") unless group_subscription
      group_subscription
    end

    def build_survey_responce(response_details)
      ::SurveyResponse.new(surveymonkey_id: response_details['id'],
                           total_time: response_details['total_time'],
                           ip: response_details['ip_address'],
                           analyze_url: response_details['analyze_url'],
                           modified_at: response_details['date_modified'])
    end

    def build_survey_answers(response_details)
      response_details['pages'][0]['questions'].map do |question_answer|
        question = questions.detect {|q| q['id'] == question_answer['id']}
        AnswerProcessor.new(question, question_answer).process
      end
    end

    def questions
      @questions ||= begin
        survey_details = @client.survey_with_details(SURVEY_ID)
        survey_details['pages'][0]['questions']
      end
    end
  end
end