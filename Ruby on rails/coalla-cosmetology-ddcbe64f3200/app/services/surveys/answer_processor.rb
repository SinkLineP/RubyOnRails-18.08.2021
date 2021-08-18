require 'surveymonkey'

module Surveys
  class AnswerProcessor
    IMPORTANT_ID = 942320058

    def initialize(question, question_answer)
      @question_answer = question_answer
      @question = question
    end

    def process
      {
        question: question_text,
        answer: answer_text,
        important: important
      }
    end

    protected

    def question_text
      @question['headings'].map { |h| h['heading'] }.join("\s")
    end

    def answer_text
      @question_answer['answers'].map do |answer|
        if answer['choice_id']
          choice_text(answer['choice_id'])
        else
          answer['text']
        end
      end.join(",\s")
    end

    def choice_text(choice_id)
      choice = @question['answers']['choices'].detect { |c| c['id'] == choice_id }
      choice['text']
    end

    def important
      @question['id'].to_i == IMPORTANT_ID
    end
  end
end