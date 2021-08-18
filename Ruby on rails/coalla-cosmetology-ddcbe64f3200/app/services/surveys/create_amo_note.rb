module Surveys
  class CreateAmoNote
    include ApplicationHelper

    def initialize(survey_response)
      @survey_response = survey_response
      @group_subscription = survey_response.group_subscription
    end

    def create!
      return if @group_subscription.amocrm_id.blank?
      amo_note = Amocrm::Entities::Note.new(element_id: @group_subscription.amocrm_id,
                                            element_type: Amocrm::ElementType::LEAD,
                                            note_type: Note::COMMENT,
                                            date_create: @survey_response.modified_at,
                                            text: survey_response_text)
      amo_note.save!
      amo_note
    end

    private

    def survey_response_text
      result = StringIO.new
      result << "Опрос #{format_date_time_full(@survey_response.modified_at)}, IP: #{@survey_response.ip}, #{@survey_response.analyze_url}\n\n"
      @survey_response.survey_answers.each do |survey_answer|
        result << "#{survey_answer.question}\n"
        result << "#{survey_answer.answer}\n\n"
      end
      result.string
    end
  end
end