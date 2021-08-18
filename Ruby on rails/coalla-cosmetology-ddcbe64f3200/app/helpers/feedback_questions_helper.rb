module FeedbackQuestionsHelper
  def feedback_question_type_options
    FeedbackQuestion::TYPES.map do |type|
      [
        I18n.t("feedback_questions.#{type.underscore}"),
        type,
        { 'data-feedback-form' => type == 'AbsenteeismQuestion' ? 'absenteeism_form' : 'default_feedback_form' }
      ]
    end
  end
end