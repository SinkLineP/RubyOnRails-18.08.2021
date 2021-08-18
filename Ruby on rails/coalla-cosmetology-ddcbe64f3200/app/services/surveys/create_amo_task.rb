module Surveys
  class CreateAmoTask
    MIN_ANSWER_VALUE = 6

    def initialize(survey_response)
      @survey_response = survey_response
      @group_subscription = survey_response.group_subscription
    end

    def create!
      answer = @survey_response.survey_answers.detect(&:important?).try(:answer)
      return if answer.blank?
      value = answer.match(/[0-9]+/)[0]
      return if value.blank?
      return if value.to_i > MIN_ANSWER_VALUE
      return if @group_subscription.amocrm_id.blank?
      lead = Amocrm::Entities::Lead.find(@group_subscription.amocrm_id)
      return unless lead
      amo_task = Amorail::Task.new(text: 'По результатам опроса клиент недоволен',
                                   complete_till: Time.current + 1.day,
                                   element_id: lead.id,
                                   element_type: Amocrm::ElementType::LEAD,
                                   task_type: Amorail.properties.tasks['follow_up'].id,
                                   responsible_user_id: lead.responsible_user_id)
      amo_task.save!
      amo_task
    end
  end
end