# frozen_string_literal: true

# Контроллер раздела "Опросы"
# @see app/views/admin/survey_responses
module Admin
  class SurveyResponsesController < Admin::AdminController
    authorize_resource

    def index
      @survey_responses = SurveyResponse.ordered.paginate(page: params[:page] || 1, per_page: 20)
    end
  end
end
