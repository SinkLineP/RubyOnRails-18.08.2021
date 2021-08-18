class SurveymonkeyController < ActionController::Base
  skip_before_filter :verify_authenticity_token
  skip_before_action :basic_authenticate

  format 'json'
  def response_completed
    logger.info(request.raw_post)
    Delayed::Job.enqueue(Surveys::CompleteResponse.new(request.raw_post))
    render body: {}, status: 200
  end
end