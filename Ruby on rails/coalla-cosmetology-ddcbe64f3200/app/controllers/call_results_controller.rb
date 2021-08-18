class CallResultsController < ActionController::Base

  skip_before_filter :verify_authenticity_token

  def index
    render nothing: true
  end

  def create
    call_result = CallResult.find(params[:id])
    call_result.with_lock do
      call_result.update!(params.permit(:status, :code, :duration, :user_input))
    end
    render nothing: true
  end
end