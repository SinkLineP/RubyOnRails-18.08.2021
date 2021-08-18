module Surveys
  class CompleteResponse
    def initialize(request_body)
      @request_body = request_body
    end

    def perform
      decoded_response = ::ActiveSupport::JSON.decode(@request_body)
      response_id = decoded_response['resources']['respondent_id']
      survey_response = Surveys::Responses.new(response_id).create!
      Surveys::CreateAmoNote.new(survey_response).create!
      Surveys::CreateAmoTask.new(survey_response).create!
    rescue Surveys::UnprocessableDataException => ex
      Rails.logger.error("Unable to process survey. #{ex.message}")
    end

    def failure(job)
      error = StandardError.new("Unable to process survey. Job #{job.id}")
      error.set_backtrace(job.last_error)
      ::CustomExceptionNotifier.notify_exception(error)
    end
  end
end