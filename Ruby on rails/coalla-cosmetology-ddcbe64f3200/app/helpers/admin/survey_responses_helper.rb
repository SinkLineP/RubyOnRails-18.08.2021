module Admin
  module SurveyResponsesHelper

    def answer_mark(survey_answer)
      survey_answer.try(:answer).to_s.split(' ').last
    end

  end
end